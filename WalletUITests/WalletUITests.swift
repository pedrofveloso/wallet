//
//  WalletUITests.swift
//  WalletUITests
//
//  Created by Pedro Veloso on 23/07/22.
//

import XCTest
@testable import Wallet

class WalletUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testEndToEndFlow() throws {
        let robot = Robot(app: XCUIApplication())
        robot.start()
        
        robot
            .financialInfoCardViewShouldBeVisible()
            .transactionsTableViewShouldBeVisible(false)
            .tapAddTransactionButton()
            .addTransactionModalShouldBeVisible()
            .addTransactionTitleLabelShouldBeVisible()
            .addTransactionSelectorTypeShouldBeVisible()
            .addTransactionDescriptionTextFieldShouldBeVisible()
            .addTransactionAmountSelectorShouldBeVisible()
            .addTransanctionSubmitButtonShouldBeEnabled(false)
            .selectTransactionTypeAsIncome()
            .fillDescription(with: "Salary")
            .fillAmount(with: "2,000.00")
            .tapDecreaseAmount(count: 2)
            .tapIncreaseAmount()
            .addTransanctionSubmitButtonShouldBeEnabled(true)
            .tapAddTransactionSubmitButton()
            .transactionsTableViewShouldBeVisible(true)
            .deleteTransaction()
    }
}

class Robot {
    private let app: XCUIApplication

    // MARK: Statement
    private let financialInfoCardViewId = "financialInfoCardView"
    private let transactionTableViewId = "transactionTableView"
    private let addTransactionButtonId = "addTransactionButton"
    
    // MARK: Add transaction
    private let contentViewId = "contentView"
    private let titleLabelId = "titleLabel"
    private let transactionTypeSelectorId = "transactionTypeSelector"
    private let descriptionTextFieldId = "descriptionTextField"
    private let amountSelectorId = "amountSelector"
    private let submitButtonId = "submitButton"
    private let transactionTypePickerViewId = "transactionTypePickerView"
    private let toolbarOk = "OK"
    private let amountSelectorUp = "upSelector"
    private let amountSelectorDown = "downSelector"
    private let cellDelete = "Delete"
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    func start() {
        app.launchArguments = ["-runningUITests"]
        app.launch()
    }
    
    // MARK: - Actions
    @discardableResult
    func tapAddTransactionButton() -> Self {
        app.buttons[addTransactionButtonId].tap()

        return self
    }
    
    @discardableResult
    func selectTransactionTypeAsIncome() -> Self {
        app.textFields[transactionTypeSelectorId].tap()
        app.pickers[transactionTypePickerViewId].swipeUp()
        
        app.buttons[toolbarOk].tap()
        
        return self
    }
    
    @discardableResult
    func fillDescription(with text: String) -> Self {
        let descriptionTextField = app.textFields[descriptionTextFieldId]
        
        descriptionTextField.tap()
        descriptionTextField.typeText(text)
        
        app.buttons[toolbarOk].tap()
        
        return self
    }
    
    @discardableResult
    func fillAmount(with text: String) -> Self {
        let amountSelector = app.textFields[amountSelectorId]
        
        amountSelector.tap()
        amountSelector.typeText(text)
        
        app.buttons[toolbarOk].tap()
        
        return self
    }
    
    @discardableResult
    func tapDecreaseAmount(count: Int = 1) -> Self {
        let amountSelector = app.textFields[amountSelectorId]
        
        amountSelector.buttons[amountSelectorDown].tap(withNumberOfTaps: count, numberOfTouches: 1)
        
        return self
    }
    
    @discardableResult
    func tapIncreaseAmount() -> Self {
        let amountSelector = app.textFields[amountSelectorId]
        
        amountSelector.buttons[amountSelectorUp].tap()
        
        return self
    }
    
    @discardableResult
    func tapAddTransactionSubmitButton() -> Self {
        app.buttons[submitButtonId].tap()
        
        return self
    }
    
    @discardableResult
    func deleteTransaction() -> Self {
        app.cells.firstMatch.swipeLeft()
        
        app.buttons[cellDelete].tap()
        
        return self
    }
    
    // MARK: - Assertions
    @discardableResult
    func financialInfoCardViewShouldBeVisible() -> Self {
        let isFinancialInfoCardViewVisible = app.otherElements[financialInfoCardViewId].isHittable

        XCTAssertTrue(isFinancialInfoCardViewVisible)
        
        return self
    }
    
    @discardableResult
    func transactionsTableViewShouldBeVisible(_ value: Bool) -> Self {
        let isTransactionTableViewVisible = app.otherElements[transactionTableViewId].waitForExistence(timeout: 2)
        
        XCTAssertEqual(isTransactionTableViewVisible, value)
        
        return self
    }
    
    @discardableResult
    func addTransactionModalShouldBeVisible() -> Self {
        let isContentViewVisible = app.otherElements[contentViewId].isHittable
        
        XCTAssertTrue(isContentViewVisible)
        
        return self
    }
    
    @discardableResult
    func addTransactionTitleLabelShouldBeVisible() -> Self {
        let isTitleLabelVisible = app.staticTexts[titleLabelId].isHittable
        
        XCTAssertTrue(isTitleLabelVisible)
        
        return self
    }
    
    @discardableResult
    func addTransactionSelectorTypeShouldBeVisible() -> Self {
        let isSelectorTypeVisible = app.textFields[transactionTypeSelectorId].isHittable
        
        XCTAssertTrue(isSelectorTypeVisible)
        
        return self
    }
    
    @discardableResult
    func addTransactionDescriptionTextFieldShouldBeVisible() -> Self {
        let isDescriptionVisible = app.textFields[descriptionTextFieldId].isHittable
        
        XCTAssertTrue(isDescriptionVisible)
        
        return self
    }
    
    @discardableResult
    func addTransactionAmountSelectorShouldBeVisible() -> Self {
        let isAmountSelectorVisible = app.textFields[amountSelectorId].isHittable
        
        XCTAssertTrue(isAmountSelectorVisible)
        
        return self
    }
    
    @discardableResult
    func addTransanctionSubmitButtonShouldBeEnabled(_ value: Bool) -> Self {
        
        let isSubmitButtonEnabled = app.buttons[submitButtonId].isEnabled
        
        XCTAssertEqual(isSubmitButtonEnabled, value)
        
        return self
    }
}

