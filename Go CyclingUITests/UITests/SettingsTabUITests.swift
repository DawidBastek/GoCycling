//
//  SettingsTabUITests.swift
//  Go CyclingUITests
//
//  UI tests for the Settings tab.
//

import XCTest

final class SettingsTabUITests: BaseTest {

    // MARK: - Configuration

    override var additionalLaunchArguments: [String] { [LaunchArguments.preloadTestRoute] }

    // MARK: - Test: Delete All Stored Routes With Confirmation

    func testDeleteAllStoredRoutes() throws {
        TabBarPage()
            .goToHistory()
            .verifyListHasAtLeastOneRoute()

        TabBarPage()
            .goToSettings()
            .tapDeleteAllRoutes()
            .verifyDeleteAllAlertShown()
            .cancelDeleteAll()

        TabBarPage()
            .goToHistory()
            .verifyListHasAtLeastOneRoute()

        TabBarPage()
            .goToSettings()
            .tapDeleteAllRoutes()
            .confirmDeleteAll()

        TabBarPage()
            .goToHistory()
            .verifyEmptyState()
    }

    // MARK: - Test: Units Toggle Affects History Display

    func testUnitsToggleAffectsHistoryDisplay() throws {
        TabBarPage()
            .goToSettings()
            .tapMetric()
            .verifyMetricUnitSelected()

        TabBarPage()
            .goToHistory()

        SnapshotHelper.verifySnapshot(
            of: app,
            named: "history_list_metric_units",
            testCase: self
        )

        TabBarPage()
            .goToSettings()
            .tapImperial()
            .verifyImperialUnitSelected()

        TabBarPage()
            .goToHistory()

        SnapshotHelper.verifySnapshot(
            of: app,
            named: "history_list_imperial_units",
            testCase: self
        )
        
        TabBarPage()
            .goToSettings()
            .tapMetric()
            .verifyMetricUnitSelected()
    }
}
