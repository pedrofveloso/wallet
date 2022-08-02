//
//  AddTransactionViewControllerTests.swift
//  WalletTests
//
//  Created by Pedro Veloso on 01/08/22.
//

@testable import Wallet
import XCTest

class AddTransactionViewControllerTests: XCTestCase {
    var sut: AddTransactionViewController?
    var presenterMock: AddTransactionPresenterMock?

    override func setUpWithError() throws {
        presenterMock = AddTransactionPresenterMock()
        sut = AddTransactionViewController(presenter: presenterMock!)
    }
    
    func testPickerViewNumberOfRows_ShouldCallPresenterAvailableTransactionTypesCount() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        let presenter = try XCTUnwrap(presenterMock)
        ignoreFirstFormValidation()
        
        // When
        let numberOfRows = sut.pickerView(.init(), numberOfRowsInComponent: 0)
        
        // Then
        XCTAssertEqual(numberOfRows, 2)
        XCTAssertEqual(presenter.calledMethods, [.availableTransactionTypes])
    }

    func testPickerViewTitleForRow_ShouldCallPresenterAvailableTransactionTypesAndReturnTypeStringCapitalized() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        let presenter = try XCTUnwrap(presenterMock)
        ignoreFirstFormValidation()
        
        // When
        let title = sut.pickerView(.init(), titleForRow: 1, forComponent: 0)
        
        // Then
        XCTAssertEqual(title, "Income")
        XCTAssertEqual(presenter.calledMethods, [.availableTransactionTypes])
    }
    
    func testDidSelectUp_WhenSelectorIsAmount_ShouldIncreaseAmountAndValidateForm() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        let presenter = try XCTUnwrap(presenterMock)
        ignoreFirstFormValidation()
        
        // When
        sut.didSelectUp(selector: sut.amountSelector)
        
        // Then
        XCTAssertEqual(presenter.calledMethods, [.increasedAmount, .getTransactionModel])
    }
    
    func testDidSelectUp_WhenSelectorIsNotAmount_ShouldNotCallAnyPresenterMethod() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        let presenter = try XCTUnwrap(presenterMock)
        ignoreFirstFormValidation()
        
        // When
        sut.didSelectUp(selector: sut.transactionTypeSelector)
        
        // Then
        XCTAssertEqual(presenter.calledMethods, [])
    }
    
    func testDidSelectDown_WhenSelectorIsTransactionType_ShouldNotCallAnyPresenterMethod() throws {
        let sut = try XCTUnwrap(sut)
        let presenter = try XCTUnwrap(presenterMock)
        ignoreFirstFormValidation()
        
        // When
        sut.didSelectDown(selector: sut.transactionTypeSelector)
        
        // Then
        XCTAssertEqual(presenter.calledMethods, [])
    }
    
    func testDidSelectDown_WhenSelectorIsAmount_ShouldDecreaseAmountAndValidateForm() throws {
        let sut = try XCTUnwrap(sut)
        let presenter = try XCTUnwrap(presenterMock)
        ignoreFirstFormValidation()
        
        // When
        sut.didSelectDown(selector: sut.amountSelector)
        
        // Then
        XCTAssertEqual(presenter.calledMethods, [.decreasedAmount, .getTransactionModel])
    }
    
    func testDidSelectDown_WhenSelectorIsDescription_ShouldNotCallAnyPresenterMethod() throws {
        let sut = try XCTUnwrap(sut)
        let presenter = try XCTUnwrap(presenterMock)
        ignoreFirstFormValidation()
        
        // When
        sut.didSelectDown(selector: sut.descriptionTextField)
        
        // Then
        XCTAssertEqual(presenter.calledMethods, [])
    }
}

private extension AddTransactionViewControllerTests {
    func ignoreFirstFormValidation() {
        presenterMock?.calledMethods.removeAll(where: { $0 == .getTransactionModel })
    }
}
