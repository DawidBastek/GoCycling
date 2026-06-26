//
//  BasePage.swift
//  Go CyclingUITests
//
//  Created for UI Testing with Page Object Pattern.
//

import XCTest

/// Base class for all Page Objects. Provides common helpers for element interaction.
class BasePage {
    let app = XCUIApplication()

    // MARK: - Helpers

    /// Waits for an element to exist.
    @discardableResult
    func waitForElement(_ element: XCUIElement) -> Bool {
        return element.waitForExistence(timeout: Timeouts.waitForExistence)
    }

    /// Scrolls in a direction until the element exists and is fully visible on screen.
    /// Handles elements that are outside the accessibility hierarchy (off-screen in Form/List).
    @discardableResult
    func scrollToElement(_ element: XCUIElement, direction: XCUIElement.direction = .up, maxAttempts: Int = 10) -> Self {
        var attempts = 0
        while attempts < maxAttempts {
            if element.exists {
                let frame = element.frame
                let appFrame = app.frame
                if frame.minY >= appFrame.minY && frame.maxY <= appFrame.maxY {
                    break
                }
            }
            app.shortSwipe(direction)
            attempts += 1
        }
        return self
    }
}
