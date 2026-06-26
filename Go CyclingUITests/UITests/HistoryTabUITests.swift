//
//  HistoryTabUITests.swift
//  Go CyclingUITests
//
//  UI tests for the History tab with preloaded test route and snapshot verification.
//

import XCTest

final class HistoryTabUITests: BaseTest {

    // MARK: - Configuration

    override var additionalLaunchArguments: [String] { [LaunchArguments.preloadTestRoute] }

    // MARK: - Test: History List and Route Detail Snapshots

    func testHistoryRouteDetails() throws {
        TabBarPage()
            .goToHistory()
            .verifyListHasAtLeastOneRoute()

        SnapshotHelper.verifySnapshot(
            of: app,
            named: "history_list_with_routes",
            testCase: self
        )

        HistoryPage()
            .tapRoute(at: 2)
            .verifyRouteDetailsMapDisplayed()

        SnapshotHelper.verifySnapshot(
            of: app,
            named: "history_route_details",
            testCase: self
        )
    }

    // MARK: - Test: Delete Route From History

    func testDeleteRoute() throws {
        TabBarPage()
            .goToHistory()
            .verifyNumberOfCells(3)
            .swipeToDelete(routeAt: 1)
            .tapDeleteButton()
            .verifyDeleteAlertShown()
            .cancelDelete()
            .verifyNumberOfCells(3)
            .swipeToDelete(routeAt: 1)
            .tapDeleteButton()
            .verifyDeleteAlertShown()
            .confirmDelete()
            .verifyNumberOfCells(2)
    }
}
