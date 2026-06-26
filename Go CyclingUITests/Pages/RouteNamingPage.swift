//
//  RouteNamingPage.swift
//  Go CyclingUITests
//
//  Page Object for the Route Naming modal sheet displayed after stopping a ride.
//

import XCTest

final class RouteNamingPage: BasePage {

    // MARK: - Elements

    private lazy var saveWithoutCategoryButton = app.buttons[AutomationIDs.Cycle.saveRouteWithoutCategoryButton].firstMatch
    private lazy var saveButton = app.buttons[AutomationIDs.Cycle.saveRouteNameButton].firstMatch
    private lazy var categoryNameTextField = app.textFields[AutomationIDs.Cycle.categoryNameTextField].firstMatch

    // MARK: - Actions

    @discardableResult
    func tapSaveWithoutCategory() -> CyclePage {
        saveWithoutCategoryButton.tap()
        return CyclePage()
    }

    @discardableResult
    func typeCategoryName(_ name: String) -> Self {
        categoryNameTextField.tap()
        categoryNameTextField.typeText(name)
        return self
    }

    @discardableResult
    func tapSave() -> Self {
        saveButton.tap()
        return self
    }
}
