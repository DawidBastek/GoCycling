//
//  SnapshotHelper.swift
//  Go CyclingUITests
//
//  Lightweight snapshot testing helper using XCUIScreenshot.
//  No external dependencies required.
//
//  Usage:
//    1. First run with `record = true` to generate reference images.
//    2. Subsequent runs with `record = false` compare against the reference.
//
//  Reference images are stored in:
//    Go CyclingUITests/ReferenceSnapshots/<TestClass>/<testName>_<snapshotName>.png
//

import XCTest

enum SnapshotHelper {

    /// Directory where reference snapshots are stored.
    /// Relative to the UI test bundle's source root.
    private static var referenceDirectory: URL {
        // __FILE__ trick to locate source directory at runtime
        let fileURL = URL(fileURLWithPath: #file)
        let uiTestsDir = fileURL
            .deletingLastPathComponent() // Helpers/
            .deletingLastPathComponent() // Go CyclingUITests/
        return uiTestsDir.appendingPathComponent("ReferenceSnapshots")
    }

    /// Captures a snapshot and either records it or compares it to an existing reference.
    ///
    /// - Parameters:
    ///   - element: The UI element to snapshot (use `app` for full screen).
    ///   - name: A descriptive name for the snapshot (e.g. "default_state").
    ///   - testCase: The XCTestCase instance (`self` in test method).
    ///   - record: Set to `true` to save a new reference image. Set to `false` to compare.
    ///   - perPixelTolerance: Allowed color difference per pixel (0.0–1.0). Default 0.05.
    ///   - overallTolerance: Fraction of pixels that can differ. Default 0.01 (1%).
    static func verifySnapshot(
        of element: XCUIElement,
        named name: String,
        testCase: XCTestCase,
        record: Bool = false,
        perPixelTolerance: CGFloat = 0.05,
        overallTolerance: CGFloat = 0.01,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let screenshot = element.screenshot()
        let testClassName = String(describing: type(of: testCase))
        let testMethodName = testCase.name
            .replacingOccurrences(of: "-[", with: "")
            .replacingOccurrences(of: "]", with: "")
            .replacingOccurrences(of: " ", with: "_")

        let snapshotFileName = "\(testMethodName)_\(name).png"
        let classDirectory = referenceDirectory.appendingPathComponent(testClassName)
        let referenceURL = classDirectory.appendingPathComponent(snapshotFileName)

        // Always attach the current screenshot to the test result
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "Snapshot - \(name)"
        attachment.lifetime = .keepAlways
        testCase.add(attachment)

        if record {
            // Create directory if needed
            try? FileManager.default.createDirectory(at: classDirectory, withIntermediateDirectories: true)
            // Write image
            let pngData = screenshot.pngRepresentation
            do {
                try pngData.write(to: referenceURL)
                XCTFail("Snapshot recorded: \(referenceURL.path). Set record = false to verify.",
                        file: file, line: line)
            } catch {
                XCTFail("Failed to write reference snapshot: \(error)", file: file, line: line)
            }
        } else {
            // Compare with reference
            guard FileManager.default.fileExists(atPath: referenceURL.path) else {
                XCTFail("Reference snapshot not found at: \(referenceURL.path). Run with record = true first.",
                        file: file, line: line)
                return
            }

            guard let referenceData = try? Data(contentsOf: referenceURL),
                  let referenceImage = UIImage(data: referenceData),
                  let currentImage = UIImage(data: screenshot.pngRepresentation) else {
                XCTFail("Failed to load images for comparison.", file: file, line: line)
                return
            }

            let result = compareImages(reference: referenceImage, current: currentImage,
                                       perPixelTolerance: perPixelTolerance,
                                       overallTolerance: overallTolerance)

            if !result.passed {
                // Attach the reference for comparison
                let refAttachment = XCTAttachment(image: referenceImage)
                refAttachment.name = "Reference - \(name)"
                refAttachment.lifetime = .keepAlways
                testCase.add(refAttachment)

                // Generate and attach a visual diff image highlighting changed pixels
                if let diffImage = generateDiffImage(reference: referenceImage, current: currentImage,
                                                     perPixelTolerance: perPixelTolerance) {
                    let diffAttachment = XCTAttachment(image: diffImage)
                    diffAttachment.name = "Diff - \(name)"
                    diffAttachment.lifetime = .keepAlways
                    testCase.add(diffAttachment)

                    // Save diff and actual (failed) screenshot to ReferenceSnapshots for easy inspection
                    let diffFileName = snapshotFileName.replacingOccurrences(of: ".png", with: "_diff.png")
                    let failedFileName = snapshotFileName.replacingOccurrences(of: ".png", with: "_failed.png")
                    let diffURL = classDirectory.appendingPathComponent(diffFileName)
                    let failedURL = classDirectory.appendingPathComponent(failedFileName)

                    try? FileManager.default.createDirectory(at: classDirectory, withIntermediateDirectories: true)

                    if let diffPNG = diffImage.pngData() {
                        try? diffPNG.write(to: diffURL)
                    }
                    try? screenshot.pngRepresentation.write(to: failedURL)
                }

                XCTFail("Snapshot mismatch for '\(name)': \(result.message)", file: file, line: line)
            }
        }
    }

    // MARK: - Image Comparison

    private struct ComparisonResult {
        let passed: Bool
        let message: String
    }

    private static func compareImages(
        reference: UIImage,
        current: UIImage,
        perPixelTolerance: CGFloat,
        overallTolerance: CGFloat
    ) -> ComparisonResult {
        guard let refCG = reference.cgImage, let curCG = current.cgImage else {
            return ComparisonResult(passed: false, message: "Unable to get CGImage")
        }

        let refWidth = refCG.width
        let refHeight = refCG.height
        let curWidth = curCG.width
        let curHeight = curCG.height

        // Allow minor size differences (e.g. status bar clock change)
        if abs(refWidth - curWidth) > 2 || abs(refHeight - curHeight) > 2 {
            return ComparisonResult(passed: false,
                                    message: "Size mismatch: ref=\(refWidth)x\(refHeight), current=\(curWidth)x\(curHeight)")
        }

        let width = min(refWidth, curWidth)
        let height = min(refHeight, curHeight)
        let totalPixels = width * height

        guard totalPixels > 0 else {
            return ComparisonResult(passed: false, message: "Image has 0 pixels")
        }

        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

        var refPixels = [UInt8](repeating: 0, count: height * bytesPerRow)
        var curPixels = [UInt8](repeating: 0, count: height * bytesPerRow)

        guard let refContext = CGContext(data: &refPixels, width: width, height: height,
                                         bitsPerComponent: 8, bytesPerRow: bytesPerRow,
                                         space: colorSpace, bitmapInfo: bitmapInfo),
              let curContext = CGContext(data: &curPixels, width: width, height: height,
                                         bitsPerComponent: 8, bytesPerRow: bytesPerRow,
                                         space: colorSpace, bitmapInfo: bitmapInfo) else {
            return ComparisonResult(passed: false, message: "Unable to create bitmap contexts")
        }

        refContext.draw(refCG, in: CGRect(x: 0, y: 0, width: width, height: height))
        curContext.draw(curCG, in: CGRect(x: 0, y: 0, width: width, height: height))

        var differentPixels = 0
        let perPixelThreshold = UInt8(perPixelTolerance * 255)

        for i in stride(from: 0, to: totalPixels * bytesPerPixel, by: bytesPerPixel) {
            let rDiff = absDiff(refPixels[i], curPixels[i])
            let gDiff = absDiff(refPixels[i + 1], curPixels[i + 1])
            let bDiff = absDiff(refPixels[i + 2], curPixels[i + 2])
            let aDiff = absDiff(refPixels[i + 3], curPixels[i + 3])

            if rDiff > perPixelThreshold || gDiff > perPixelThreshold ||
               bDiff > perPixelThreshold || aDiff > perPixelThreshold {
                differentPixels += 1
            }
        }

        let diffRatio = CGFloat(differentPixels) / CGFloat(totalPixels)

        if diffRatio > overallTolerance {
            let percentage = String(format: "%.2f", diffRatio * 100)
            return ComparisonResult(passed: false,
                                    message: "\(percentage)% of pixels differ (tolerance: \(overallTolerance * 100)%)")
        }

        return ComparisonResult(passed: true, message: "")
    }

    private static func absDiff(_ a: UInt8, _ b: UInt8) -> UInt8 {
        return a > b ? a - b : b - a
    }

    // MARK: - Diff Image Generation

    /// Generates a visual diff image where:
    /// - Unchanged pixels are shown dimmed (30% opacity of the reference)
    /// - Changed pixels are highlighted in red
    private static func generateDiffImage(
        reference: UIImage,
        current: UIImage,
        perPixelTolerance: CGFloat
    ) -> UIImage? {
        guard let refCG = reference.cgImage, let curCG = current.cgImage else { return nil }

        let width = min(refCG.width, curCG.width)
        let height = min(refCG.height, curCG.height)

        guard width > 0 && height > 0 else { return nil }

        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

        var refPixels = [UInt8](repeating: 0, count: height * bytesPerRow)
        var curPixels = [UInt8](repeating: 0, count: height * bytesPerRow)

        guard let refContext = CGContext(data: &refPixels, width: width, height: height,
                                         bitsPerComponent: 8, bytesPerRow: bytesPerRow,
                                         space: colorSpace, bitmapInfo: bitmapInfo),
              let curContext = CGContext(data: &curPixels, width: width, height: height,
                                         bitsPerComponent: 8, bytesPerRow: bytesPerRow,
                                         space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }

        refContext.draw(refCG, in: CGRect(x: 0, y: 0, width: width, height: height))
        curContext.draw(curCG, in: CGRect(x: 0, y: 0, width: width, height: height))

        // Create diff pixel buffer
        var diffPixels = [UInt8](repeating: 0, count: height * bytesPerRow)
        let perPixelThreshold = UInt8(perPixelTolerance * 255)

        for i in stride(from: 0, to: width * height * bytesPerPixel, by: bytesPerPixel) {
            let rDiff = absDiff(refPixels[i], curPixels[i])
            let gDiff = absDiff(refPixels[i + 1], curPixels[i + 1])
            let bDiff = absDiff(refPixels[i + 2], curPixels[i + 2])
            let aDiff = absDiff(refPixels[i + 3], curPixels[i + 3])

            let pixelChanged = rDiff > perPixelThreshold || gDiff > perPixelThreshold ||
                               bDiff > perPixelThreshold || aDiff > perPixelThreshold

            if pixelChanged {
                // Highlight changed pixel in red
                diffPixels[i] = 255      // R
                diffPixels[i + 1] = 0    // G
                diffPixels[i + 2] = 0    // B
                diffPixels[i + 3] = 220  // A
            } else {
                // Dim unchanged pixel (30% opacity grayscale of reference)
                let gray = UInt8((Int(refPixels[i]) + Int(refPixels[i + 1]) + Int(refPixels[i + 2])) / 3)
                diffPixels[i] = gray       // R
                diffPixels[i + 1] = gray   // G
                diffPixels[i + 2] = gray   // B
                diffPixels[i + 3] = 76     // A (~30%)
            }
        }

        // Create image from diff pixels
        guard let diffContext = CGContext(data: &diffPixels, width: width, height: height,
                                          bitsPerComponent: 8, bytesPerRow: bytesPerRow,
                                          space: colorSpace, bitmapInfo: bitmapInfo),
              let diffCGImage = diffContext.makeImage() else {
            return nil
        }

        return UIImage(cgImage: diffCGImage)
    }
}
