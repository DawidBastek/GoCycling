//
//  StatisticsTabUITests.swift
//  Go CyclingUITests
//
//  UI tests for the Statistics tab.
//

import XCTest

final class StatisticsTabUITests: BaseTest {

    // MARK: - Configuration

    override var additionalLaunchArguments: [String] { [LaunchArguments.preloadTestRoute] }

    // MARK: - Test: Cycling Chart Navigation and Content

    func testCyclingChartNavigationAndContent() throws {
        TabBarPage()
            .goToStatistics()
            .verifyAllChartRowsVisible()

        SnapshotHelper.verifySnapshot(
            of: app,
            named: "statistics_charts_list",
            testCase: self
        )

        StatisticsPage()
            .tapChartPast7Days()
            .verifyChartDetailDisplayed()

        SnapshotHelper.verifySnapshot(
            of: app,
            named: "statistics_chart_detail_7days",
            testCase: self
        )

        StatisticsPage()
            .navigateBack()
            .verifyStatisticsDisplayed()
    }
}
