//
//  TabBarPage.swift
//  Go CyclingUITests
//
//  Page Object for the main TabView navigation.
//

import XCTest

final class TabBarPage: BasePage {

    // MARK: - Elements

    private lazy var cycleTab = app.tabBars.buttons["Cycle"].firstMatch
    private lazy var historyTab = app.tabBars.buttons["History"].firstMatch
    private lazy var statisticsTab = app.tabBars.buttons["Statistics"].firstMatch
    private lazy var settingsTab = app.tabBars.buttons["Settings"].firstMatch

    // MARK: - Actions

    @discardableResult
    func goToCycle() -> CyclePage {
        cycleTab.tap()
        return CyclePage()
    }

    @discardableResult
    func goToHistory() -> HistoryPage {
        historyTab.tap()
        return HistoryPage()
    }

    @discardableResult
    func goToStatistics() -> StatisticsPage {
        statisticsTab.tap()
        return StatisticsPage()
    }

    @discardableResult
    func goToSettings() -> SettingsPage {
        settingsTab.tap()
        return SettingsPage()
    }
}
