//
//  SettingsPage.swift
//  Go CyclingUITests
//
//  Page Object for the Settings tab.
//

import XCTest

final class SettingsPage: BasePage {

    // MARK: - Elements

    private lazy var imperialSegment = app.buttons[AutomationIDs.Settings.imperialSegment].firstMatch
    private lazy var metricSegment = app.buttons[AutomationIDs.Settings.metricSegment].firstMatch
    private lazy var deleteAllRoutesButton = app.buttons[AutomationIDs.Settings.deleteAllStoredRoutesButton].firstMatch
    private lazy var deleteAllAlert = app.alerts["Are you sure that you want to delete all stored cycling routes?"]
    private lazy var deleteAllAlertDeleteButton = deleteAllAlert.buttons["Delete"].firstMatch
    private lazy var deleteAllAlertCancelButton = deleteAllAlert.buttons["Cancel"].firstMatch

    // MARK: - Actions

    @discardableResult
    func tapImperial() -> Self {
        imperialSegment.tap()
        return self
    }

    @discardableResult
    func tapMetric() -> Self {
        metricSegment.tap()
        return self
    }

    @discardableResult
    func tapDeleteAllRoutes() -> Self {
        scrollToElement(deleteAllRoutesButton)
        deleteAllRoutesButton.tap()
        return self
    }

    @discardableResult
    func confirmDeleteAll() -> Self {
        deleteAllAlertDeleteButton.tap()
        return self
    }

    @discardableResult
    func cancelDeleteAll() -> Self {
        deleteAllAlertCancelButton.tap()
        return self
    }

    // MARK: - State Verification

    @discardableResult
    func verifyDeleteAllAlertShown(file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertTrue(waitForElement(deleteAllAlert),
                      "Delete all routes alert should be displayed", file: file, line: line)
        return self
    }

    @discardableResult
    func verifyDeleteAllAlertDismissed(file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertFalse(deleteAllAlert.exists,
                       "Delete all routes alert should be dismissed", file: file, line: line)
        return self
    }

    @discardableResult
    func verifyMetricUnitSelected(file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertTrue(metricSegment.isSelected, "Metric segment should be selected", file: file, line: line)
        return self
    }

    @discardableResult
    func verifyImperialUnitSelected(file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertTrue(imperialSegment.isSelected, "Imperial segment should be selected", file: file, line: line)
        return self
    }
}
