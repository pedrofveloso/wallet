//
//  AddTransactionPresenterTests.swift
//  WalletTests
//
//  Created by Pedro Veloso on 31/07/22.
//

@testable import Wallet
import XCTest

class AddTransactionPresenterTests: XCTestCase {
    private var sut: AddTransactionPresenter?

    override func setUpWithError() throws {
        sut = AddTransactionPresenter()
    }

    func testProperties_WhenInitialized_ShouldReturnWithDefaultValues() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        
        // Then
        XCTAssertNil(sut.type)
        XCTAssertEqual(sut.description, "")
        XCTAssertEqual(sut.amount, 0.0)
    }
    
    func testAvailableTransactionTypes() throws {
        // Given
        let availableTransactionTypes = try XCTUnwrap(sut?.availableTransactionTypes)
        
        // Then
        XCTAssertEqual(availableTransactionTypes, [.expense, .income])
    }
    
    func testChangedType_WhenIndexIsZero_ShouldReturnExpense() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        
        // When
        let type = sut.changedType(with: 0)
        
        // Then
        XCTAssertEqual(sut.type, .expense)
        XCTAssertEqual(type, "Expense")
    }
    
    func testChangedType_WhenIndexIsOne_ShouldReturnExpense() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        
        // When
        let type = sut.changedType(with: 1)
        
        // Then
        XCTAssertEqual(sut.type, .income)
        XCTAssertEqual(type, "Income")
    }
    
    func testChangeDescription_ShouldReturnSameStringValue() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        
        // Then
        XCTAssertEqual(sut.changedDescription(with: "description"), "description")
    }
    
    func testIncreasedAmount_ShouldReturnPreviousAmountPlusOneDollar() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        
        // Then
        XCTAssertEqual(sut.increasedAmount(), "$1.00")
    }
    
    func testDecreasedAmount_WhenResultAmountIsLessThanZero_ShouldReturnZeroDollars() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        
        // Then
        XCTAssertEqual(sut.decreasedAmount(), "$0.00")
    }
    
    func testDecreasedAmount_WhenResultAmountIsGreatherThanZero_ShouldReturnPreviousAmountMinusOneDollar() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        
        // When
        _ = sut.increasedAmount()
        _ = sut.increasedAmount()
        
        // Then
        XCTAssertEqual(sut.decreasedAmount(), "$1.00")
    }
    
    func testChangeAmountIfNeeded_WhenAmountIsNotNumber_ShouldReturnPreviousAmount() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        
        // When
        let amount = sut.changeAmountIfNeeded(with: "lorem")
        
        // Then
        XCTAssertEqual(amount, "$0.00")
    }
    
    func testChangeAmountIfNeeded_WhenAmountIsANegativeNumber_ShouldReturnAmountAsCurrencyIgnoringNegativeSymbol() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        
        // When
        let amount = sut.changeAmountIfNeeded(with: "-123")
        
        // Then
        XCTAssertEqual(amount, "$1.23")
    }
    
    func testChangeAmountIfNeeded_WhenAmountIsANumber_ShouldReturnAmountAsCurrency() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        
        // When
        let amount = sut.changeAmountIfNeeded(with: "10.00")
        
        // Then
        XCTAssertEqual(amount, "$10.00")
    }
    
    func testGetTransactionModel_WhenTypeIsNil_ShouldReturnNil() throws {
        // Given
        let sut = try XCTUnwrap(sut)

        // When
        _ = sut.changedDescription(with: "description")
        _ = sut.increasedAmount()
        
        // Then
        XCTAssertNil(sut.getTransactionModel())
    }
    
    func testGetTransactionModel_WhenDescriptionIsEmpty_ShouldReturnNil() throws {
        // Given
        let sut = try XCTUnwrap(sut)

        // When
        _ = sut.changedType(with: 0)
        _ = sut.increasedAmount()
        
        // Then
        XCTAssertNil(sut.getTransactionModel())
    }
    
    func testGetTransactionModel_WhenAmountIsZero_ShouldReturnNil() throws {
        // Given
        let sut = try XCTUnwrap(sut)

        // When
        _ = sut.changedType(with: 0)
        _ = sut.changedDescription(with: "description")
        
        // Then
        XCTAssertNil(sut.getTransactionModel())
    }
    
    func testGetTransactionType_WhenPropertiesAreFilled_ShouldReturnTransactionModelInstance() throws {
        // Given
        let sut = try XCTUnwrap(sut)

        // When
        _ = sut.changedType(with: 0)
        _ = sut.changedDescription(with: "description")
        _ = sut.changeAmountIfNeeded(with: "500.00")
        let instance = try XCTUnwrap(sut.getTransactionModel())
        
        // Then
        XCTAssertEqual(instance.type, .expense)
        XCTAssertEqual(instance.name, "description")
        XCTAssertEqual(instance.amount, 500.00)
    }
}
