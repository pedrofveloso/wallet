//
//  WalletUITests.swift
//  WalletUITests
//
//  Created by Pedro Veloso on 23/07/22.
//

import XCTest
@testable import Wallet

final class WalletUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testEndToEndFlow() throws {
        let robot = WalletRobot(app: XCUIApplication())
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
