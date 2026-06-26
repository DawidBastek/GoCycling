//
//  BaseTest.swift
//  Go CyclingUITests
//
//  Base class for all UI tests. Handles app launch, teardown,
//  and common system alert handling.
//

import XCTest

class BaseTest: XCTestCase {

    let app = XCUIApplication()

    /// Override in subclasses to add extra launch arguments (e.g. "-PreloadTestRoute").
    var additionalLaunchArguments: [String] { [] }

    /// Override in subclasses to clear data after each test (e.g. routes created during cycling tests).
    var clearDataOnTeardown: Bool { true }

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = true

        app.launchArguments = [LaunchArguments.uiTesting] + additionalLaunchArguments
        app.launch()

        handleLocationPermissionAlert()
    }

    override func tearDownWithError() throws {
        if clearDataOnTeardown {
            clearAllData()
        }
        app.terminate()
        try super.tearDownWithError()
    }

    // MARK: - Helpers

    /// Handles the system location permission alert by tapping "Allow While Using App".
    func handleLocationPermissionAlert() {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let alertAllowButton = springboard.buttons["Allow While Using App"]
        if alertAllowButton.waitForExistence(timeout: Timeouts.waitForExistence) {
            alertAllowButton.tap()
        }
    }

    /// Relaunches the app with -ClearAllData to remove all stored routes.
    private func clearAllData() {
        app.terminate()
        app.launchArguments = [LaunchArguments.uiTesting, LaunchArguments.clearAllData]
        app.launch()
    }
}
