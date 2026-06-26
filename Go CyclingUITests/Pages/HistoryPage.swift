//
//  HistoryPage.swift
//  Go CyclingUITests
//
//  Page Object for the History tab — bike ride list and route detail views.
//

import XCTest

final class HistoryPage: BasePage {

    // MARK: - Elements

    private lazy var emptyStateLabel = app.staticTexts[AutomationIDs.History.emptyStateLabel].firstMatch
    private lazy var firstCell = app.cells.firstMatch
    private lazy var routeDetailsMapView = app.otherElements[AutomationIDs.History.routeDetailsMapView].firstMatch
    private lazy var deleteAlert = app.alerts["Are you sure that you want to delete this route?"]
    private lazy var deleteAlertDeleteButton = deleteAlert.buttons["Delete"].firstMatch
    private lazy var deleteAlertCancelButton = deleteAlert.buttons["Cancel"].firstMatch

    // MARK: - Actions

    @discardableResult
    func tapRoute(at index: Int) -> Self {
        let identifier = AutomationIDs.History.routeCell(at: index)
        app.buttons[identifier].tap()
        return self
    }

    @discardableResult
    func swipeToDelete(routeAt index: Int) -> Self {
        let identifier = AutomationIDs.History.routeCell(at: index)
        let cell = app.buttons[identifier]
        cell.shortSwipe(.left)
        return self
    }

    @discardableResult
    func tapDeleteButton() -> Self {
        let deleteButton = app.buttons["Delete"]
        deleteButton.tap()
        return self
    }

    @discardableResult
    func confirmDelete() -> Self {
        deleteAlertDeleteButton.tap()
        return self
    }

    @discardableResult
    func cancelDelete() -> Self {
        deleteAlertCancelButton.tap()
        return self
    }

    // MARK: - State Verification

    @discardableResult
    func verifyEmptyState(file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertTrue(waitForElement(emptyStateLabel),
                      "Empty state label should be visible when no routes exist", file: file, line: line)
        return self
    }

    @discardableResult
    func verifyListHasAtLeastOneRoute(file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertTrue(waitForElement(firstCell),
                      "At least one bike ride cell should be visible", file: file, line: line)
        return self
    }

    @discardableResult
    func verifyRouteDetailsMapDisplayed(file: StaticString = #file, line: UInt = #line) -> Self {
        waitForMapToRender()
        XCTAssertTrue(waitForElement(routeDetailsMapView),
                      "Route detail map should be visible after tapping a ride", file: file, line: line)
        return self
    }

    @discardableResult
    func verifyDeleteAlertShown(file: StaticString = #file, line: UInt = #line) -> Self {
        XCTAssertTrue(waitForElement(deleteAlert),
                      "Delete confirmation alert should be displayed", file: file, line: line)
        return self
    }

    @discardableResult
    func verifyNumberOfCells(_ expectedCount: Int, file: StaticString = #file, line: UInt = #line) -> Self {
        let cellCount = app.cells.count
        XCTAssertEqual(cellCount, expectedCount,
                       "Expected \(expectedCount) cells but found \(cellCount)", file: file, line: line)
        return self
    }

    // MARK: - Helpers

    @discardableResult
    private func waitForMapToRender() -> Self {
        Thread.sleep(forTimeInterval: Timeouts.mapRender)
        return self
    }
}
