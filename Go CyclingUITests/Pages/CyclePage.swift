//
//  CyclePage.swift
//  Go CyclingUITests
//
//  Page Object for the Cycle tab - handles start/pause/resume/stop cycling flow.
//

import XCTest

final class CyclePage: BasePage {

    // MARK: - Elements

    private lazy var startButton = app.buttons[AutomationIDs.Cycle.startButton].firstMatch
    private lazy var pauseButton = app.buttons[AutomationIDs.Cycle.pauseButton].firstMatch
    private lazy var resumeButton = app.buttons[AutomationIDs.Cycle.resumeButton].firstMatch
    private lazy var stopButton = app.buttons[AutomationIDs.Cycle.stopButton].firstMatch
    private lazy var mapView = app.otherElements[AutomationIDs.Cycle.mapView].firstMatch
    private lazy var timerLabel = app.staticTexts.matching(NSPredicate(format: "label MATCHES %@", "\\d{2}:\\d{2}:\\d{2}")).firstMatch
    private lazy var stopConfirmationAlert = app.alerts["Are you sure that you want to end the current route?"]
    private lazy var alertStopButton = stopConfirmationAlert.buttons["Stop"].firstMatch
    private lazy var alertCancelButton = stopConfirmationAlert.buttons["Cancel"].firstMatch
    private lazy var speedMetric = app.staticTexts[AutomationIDs.Cycle.metricsSpeed].firstMatch
    private lazy var distanceMetric = app.staticTexts[AutomationIDs.Cycle.metricsDistance].firstMatch
    private lazy var altitudeMetric = app.staticTexts[AutomationIDs.Cycle.metricsAltitude].firstMatch

    // MARK: - Actions

    @discardableResult
    func tapStart() -> Self {
        startButton.tap()
        return self
    }

    @discardableResult
    func tapPause() -> Self {
        pauseButton.tap()
        return self
    }

    @discardableResult
    func tapResume() -> Self {
        resumeButton.tap()
        return self
    }

    @discardableResult
    func tapStop() -> Self {
        stopButton.tap()
        return self
    }

    @discardableResult
    func confirmStopAlert() -> Self {
        alertStopButton.tap()
        return self
    }

    @discardableResult
    func cancelStopAlert() -> Self {
        alertCancelButton.tap()
        return self
    }

    @discardableResult
    func waitForTimer(seconds: TimeInterval) -> Self {
        Thread.sleep(forTimeInterval: seconds)
        return self
    }

    // MARK: - State Verification

    @discardableResult
    func verifyDefaultState(file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertTrue(waitForElement(startButton), "Start button should be visible in default state", file: file, line: line)
        XCTAssertFalse(pauseButton.exists, "Pause button should not be visible in default state", file: file, line: line)
        XCTAssertFalse(stopButton.exists, "Stop button should not be visible in default state", file: file, line: line)
        XCTAssertFalse(resumeButton.exists, "Resume button should not be visible in default state", file: file, line: line)
        XCTAssertTrue(timerLabel.exists, "Timer label should be visible", file: file, line: line)
        return self
    }

    @discardableResult
    func verifyRunningState(file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertTrue(waitForElement(pauseButton), "Pause button should be visible while running", file: file, line: line)
        XCTAssertTrue(stopButton.exists, "Stop button should be visible while running", file: file, line: line)
        XCTAssertFalse(startButton.exists, "Start button should not be visible while running", file: file, line: line)
        XCTAssertFalse(resumeButton.exists, "Resume button should not be visible while running", file: file, line: line)
        return self
    }

    @discardableResult
    func verifyPausedState(file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertTrue(waitForElement(resumeButton), "Resume button should be visible while paused", file: file, line: line)
        XCTAssertTrue(stopButton.exists, "Stop button should be visible while paused", file: file, line: line)
        XCTAssertFalse(startButton.exists, "Start button should not be visible while paused", file: file, line: line)
        XCTAssertFalse(pauseButton.exists, "Pause button should not be visible while paused", file: file, line: line)
        return self
    }

    @discardableResult
    func verifyTimerAdvanced(file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertTrue(timerLabel.exists, "Timer label should exist", file: file, line: line)
        XCTAssertNotEqual(timerLabel.label, "00:00:00", "Timer should have advanced from 00:00:00", file: file, line: line)
        return self
    }

    @discardableResult
    func verifyStopConfirmationAlertShown(file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertTrue(waitForElement(stopConfirmationAlert), "Stop confirmation alert should be displayed", file: file, line: line)
        return self
    }

    @discardableResult
    func verifyStopConfirmationAlertDismissed(file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertFalse(stopConfirmationAlert.exists, "Stop confirmation alert should be dismissed", file: file, line: line)
        return self
    }

    @discardableResult
    func verifyMapViewPreseneted(file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertTrue(waitForElement(mapView), "Map view should be displayed", file: file, line: line)
        return self
    }

    @discardableResult
    func verifyMetricsPillDisplayed(file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertTrue(speedMetric.exists, "Speed metric should be visible", file: file, line: line)
        XCTAssertTrue(distanceMetric.exists, "Distance metric should be visible", file: file, line: line)
        XCTAssertTrue(altitudeMetric.exists, "Altitude metric should be visible", file: file, line: line)
        return self
    }
}
