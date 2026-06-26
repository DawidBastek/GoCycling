//
//  StatisticsPage.swift
//  Go CyclingUITests
//
//  Page Object for the Statistics tab — charts and navigation.
//

import XCTest

final class StatisticsPage: BasePage {

    // MARK: - Elements

    private lazy var navigationTitle = app.navigationBars["Cycling Statistics"].firstMatch
    private lazy var chartPast7Days = app.staticTexts[AutomationIDs.Statistics.chartPast7Days]
    private lazy var chartPast5Weeks = app.staticTexts[AutomationIDs.Statistics.chartPast5Weeks]
    private lazy var chartPast30Weeks = app.staticTexts[AutomationIDs.Statistics.chartPast30Weeks]
    private lazy var backButton = app.navigationBars.buttons["BackButton"].firstMatch

    // MARK: - Actions

    @discardableResult
    func tapChartPast7Days() -> Self {
        chartPast7Days.tap()
        return self
    }

    @discardableResult
    func navigateBack() -> Self {
        backButton.tap()
        return self
    }

    // MARK: - State Verification

    @discardableResult
    func verifyStatisticsDisplayed(file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertTrue(waitForElement(navigationTitle),
                      "Cycling Statistics navigation title should be visible", file: file, line: line)
        return self
    }

    @discardableResult
    func verifyAllChartRowsVisible(file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertTrue(waitForElement(chartPast7Days),
                      "Past 7 Days chart row should be visible", file: file, line: line)
        XCTAssertTrue(chartPast5Weeks.exists,
                      "Past 5 Weeks chart row should be visible", file: file, line: line)
        XCTAssertTrue(chartPast30Weeks.exists,
                      "Past 30 Weeks chart row should be visible", file: file, line: line)
        return self
    }

    @discardableResult
    func verifyChartDetailDisplayed(file: StaticString = #file, line: UInt = #line) -> Self {
        let detailTitle = app.navigationBars["Activity in the Past 7 Days"].firstMatch
        XCTAssertTrue(waitForElement(detailTitle),
                      "Chart detail view should be displayed", file: file, line: line)
        return self
    }
}
