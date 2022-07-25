//
//  StatementPresenterTests.swift
//  WalletTests
//
//  Created by Pedro Veloso on 25/07/22.
//

@testable import Wallet
import XCTest

class StatementPresenterTests: XCTestCase {
    private var sut: StatementPresenter?
    
    // MARK: - Total income and expenses property observers test
    func testTotalIncomeAndExpenses_whenTransactionIsRemoved_shouldRecalculateTheirValues() throws {
        // Given
        sut = .init(models: mockSingle(income: 100.0, expense: 50.0))
        
        // Then
        try assertTotalIncomeAndExpenses(income: 100.0, expenses: 50.0)
        
        // And When
        sut?.removeTransaction(indexPath: .init(row: 0, section: 0))
        
        //Then
        try assertTotalIncomeAndExpenses(income: 0.0, expenses: 50.0)
        
        // And When
        sut?.removeTransaction(indexPath: .init(row: 0, section: 0))
        
        try assertTotalIncomeAndExpenses(income: 0.0, expenses: 0.0)
    }

    // MARK: - Balance tests
    func testBalance_whenIncomeIsGreatherThanExpenses_shouldReturnCorrectPositiveValue() throws {
        // Given
        sut = .init(models: mockSingle(income: 100.0, expense: 50.0))
        
        // When
        let balance = try XCTUnwrap(sut?.balance)
        
        // Then
        XCTAssertEqual(balance, 50.0)
    }

    func testBalance_whenIncomeIsLessThanExpenses_shouldReturnCorrectNegativeValue() throws {
        // Given
        sut = .init(models: mockSingle(income: 50.0, expense: 100.0))
        
        // When
        let balance = try XCTUnwrap(sut?.balance)
        
        // Then
        XCTAssertEqual(balance, -50.0)
    }
    
    func testBalance_whenIncomeIsEqualToExpenses_shouldReturnZero() throws {
        // Given
        sut = .init(models: mockSingle(income: 100.0, expense: 100.0))
        
        // When
        let balance = try XCTUnwrap(sut?.balance)
        
        // Then
        XCTAssertEqual(balance, 0.0)
    }
    
    // MARK: - Balance progress tests
    func testBalanceProgress_whenExpensesIsZero_shouldReturnZero() throws {
        // Given
        sut = .init(models: mockSingle(income: 10.0, expense: 0.0))
        
        // When
        let progress = try XCTUnwrap(sut?.balanceProgress)
        
        // Then
        XCTAssertEqual(progress, 0.0)
    }
    
    func testBalanceProgress_whenExpensesIsNotZero_shouldReturnCorrectProgressValue() throws {
        // Given
        sut = .init(models: mockSingle(income: 10.0, expense: 5.0))
        
        // When
        let progress = try XCTUnwrap(sut?.balanceProgress)
        
        // Then
        XCTAssertEqual(progress, 0.5)
    }
    
    // MARK: - Transaction info tests
    func testTransactionInfo_whenTypeIsIncome_shouldReturnCorrectNameAndPositiveAmountValue() throws {
        // Given
        sut = .init(models: mockSingle(income: 100.0, expense: 300.0))
        
        // When
        let info = try XCTUnwrap(sut?.transactionInfo(for: .init(row: 0, section: 0)))
        
        // Then
        XCTAssertEqual(info.name, "income")
        XCTAssertEqual(info.amount, "$100.00")
    }
    
    func testTransactionInfo_whenTypeIsExpense_shouldReturnCorrectNameAndNegativeAmountValue() throws {
        // Given
        sut = .init(models: mockSingle(income: 100.0, expense: 300.0))
        
        // When
        let info = try XCTUnwrap(sut?.transactionInfo(for: .init(row: 1, section: 0)))
        
        // Then
        XCTAssertEqual(info.name, "expense")
        XCTAssertEqual(info.amount, "- $300.00")
    }
    
    // MARK: - Remove section if needed tests
    func testRemoveSectionIfNeeded_whenTransactionsIsEmpty_shouldRemoveSectionAndReturnTrue() throws {
        // Given
        sut = .init(models: [.init(date: Date(), transactions: [])])
        
        // When
        let removed = try XCTUnwrap(sut?.removeSectionIfNeeded(section: 0))
        
        // Then
        XCTAssertTrue(removed)
    }
    
    func testRemoveSectionIfNeeded_whenTransactionsIsNotEmpty_shouldReturnFalse() throws {
        // Given
        sut = .init(models: mockSingle(income: 53.0, expense: 58.0))
        
        // When
        let removed = try XCTUnwrap(sut?.removeSectionIfNeeded(section: 0))
        
        // Then
        XCTAssertFalse(removed)
    }
    
    // MARK: - Remove transaction tests
    func testRemoveTransaction_shouldRemoveTheCorrectTransaction() throws {
        // Given
        sut = .init(models: [
            .init(date: Date(), transactions: [
                .init(type: .income, name: "income 1", amount: 1000.0),
                .init(type: .expense, name: "expense 1", amount: 23.5)
            ]),
            .init(date: Date(), transactions: [
                .init(type: .expense, name: "expense 2", amount: 330.4)
            ]),
            .init(date: Date(), transactions: [
                .init(type: .income, name: "expense 3", amount: 120.0),
                .init(type: .expense, name: "expense 4", amount: 3.5)
            ])
        ])
        
        // When
        sut?.removeTransaction(indexPath: .init(row: 1, section: 2))
        
        // Then
        let transactions = try XCTUnwrap(sut?.models[2].transactions)
        let transaction = try XCTUnwrap(transactions.first)
        XCTAssertEqual(transactions.count, 1)
        XCTAssertEqual(transaction.name, "expense 3")
    }
}

private extension StatementPresenterTests {
    // MARK: - Mock
    func mockSingle(income: Decimal, expense: Decimal) -> [StatementModel] {
        let incomeInput = StatementModel.Transaction(type: .income, name: "income", amount: income)
        let expenseInput = StatementModel.Transaction(type: .expense, name: "expense", amount: expense)
        
        return [.init(date: Date(), transactions: [incomeInput, expenseInput])]
    }
    
    // MARK: - Assert utility methods
    func assertTotalIncomeAndExpenses(income: Decimal, expenses: Decimal) throws {
        let totalIncome = try XCTUnwrap(sut?.totalIncome)
        let totalExpenses = try XCTUnwrap(sut?.totalExpenses)
        XCTAssertEqual(totalIncome, income)
        XCTAssertEqual(totalExpenses, expenses)
    }
}
