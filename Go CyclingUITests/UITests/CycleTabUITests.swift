//
//  CycleTabUITests.swift
//  Go CyclingUITests
//
//  UI tests for the Cycle tab flow using Page Object Pattern.
//


import XCTest

final class CycleTabUITests: BaseTest {

    // MARK: - Test: Full Cycling Session

    func testFullCyclingSessionRecording() throws {
        CyclePage()
            .verifyMapViewPreseneted()
            .verifyMetricsPillDisplayed()
            .verifyDefaultState()

            .tapStart()
            .waitForTimer(seconds: 1)
            .verifyRunningState()

            .waitForTimer(seconds: 2)
            .verifyTimerAdvanced()

            .tapPause()
            .verifyPausedState()

            .tapResume()
            .waitForTimer(seconds: 1)

            .tapStop()
            .verifyStopConfirmationAlertShown()

            .cancelStopAlert()
            .verifyPausedState()

            .tapStop()
            .confirmStopAlert()

        RouteNamingPage()
            .typeCategoryName("Morning Ride")
            .tapSave()

        CyclePage()
            .verifyDefaultState()

        TabBarPage()
            .goToHistory()
            .verifyListHasAtLeastOneRoute()
    }

    // MARK: - Test: Stop Without Category

    func testStopAndSaveWithoutCategory() throws {
        CyclePage()
            .tapStart()
            .waitForTimer(seconds: 2)
            .tapStop()
            .confirmStopAlert()

        RouteNamingPage()
            .tapSaveWithoutCategory()

        CyclePage()
            .verifyDefaultState()

        TabBarPage()
            .goToHistory()
            .verifyListHasAtLeastOneRoute()
    }
}
