//
//  HistoryPage.swift
//  Go CyclingUITests
//
//  Page Object for the History tab — bike ride list and route detail views.
//

import XCTest

class HistoryPage: BasePage {

    // MARK: - Elements

    private var navigationTitle: XCUIElement { app.navigationBars["Cycling History"].firstMatch }
    private var emptyStateLabel: XCUIElement { app.staticTexts["No completed routes to display!"] }
    private var bikeRideList: XCUIElement { app.tables.firstMatch }

    /// The first cell in the list (most recent ride by default sort).
    private var firstCell: XCUIElement { app.tables.cells.firstMatch }

    /// Route detail map (in SingleBikeRideView).
    private var routeDetailMap: XCUIElement { app.maps.firstMatch }

    // MARK: - State Verification

    @discardableResult
    func verifyHistoryTabDisplayed() -> Self {
        XCTAssertTrue(waitForElement(navigationTitle, timeout: 5),
                      "Cycling History navigation title should be visible")
        return self
    }

    @discardableResult
    func verifyEmptyState() -> Self {
        XCTAssertTrue(waitForElement(emptyStateLabel, timeout: 3),
                      "Empty state label should be visible when no routes exist")
        return self
    }

    @discardableResult
    func verifyListHasRoutes() -> Self {
        XCTAssertTrue(waitForElement(firstCell, timeout: 5),
                      "At least one bike ride cell should be visible")
        return self
    }

    @discardableResult
    func verifyRouteDetailDisplayed() -> Self {
        XCTAssertTrue(waitForElement(routeDetailMap, timeout: 5),
                      "Route detail map should be visible after tapping a ride")
        return self
    }

    @discardableResult
    func verifyCellContains(text: String) -> Self {
        let label = app.staticTexts[text]
        XCTAssertTrue(waitForElement(label, timeout: 3),
                      "Cell should contain text: '\(text)'")
        return self
    }

    // MARK: - Actions

    /// Taps the first bike ride in the list to open its detail view.
    @discardableResult
    func tapFirstRoute() -> HistoryPage {
        XCTAssertTrue(waitForElement(firstCell, timeout: 5), "First route cell should exist")
        firstCell.tap()
        return self
    }

    /// Taps a specific route by matching text in the cell.
    @discardableResult
    func tapRoute(containing text: String) -> HistoryPage {
        let cell = app.tables.cells.containing(.staticText, identifier: text).firstMatch
        XCTAssertTrue(waitForElement(cell, timeout: 5), "Route cell containing '\(text)' should exist")
        cell.tap()
        return self
    }

    /// Navigates back from route detail to the list.
    @discardableResult
    func navigateBack() -> HistoryPage {
        app.navigationBars.buttons.firstMatch.tap()
        return self
    }

    /// Waits for the map tiles to load (for snapshot stability).
    @discardableResult
    func waitForMapToRender(seconds: TimeInterval = 3) -> HistoryPage {
        Thread.sleep(forTimeInterval: seconds)
        return self
    }
}
