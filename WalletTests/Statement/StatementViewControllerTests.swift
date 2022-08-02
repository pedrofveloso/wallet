//
//  StatementViewControllerTests.swift
//  WalletTests
//
//  Created by Pedro Veloso on 01/08/22.
//

@testable import Wallet
import XCTest

class StatementViewControllerTests: XCTestCase {
    var sut: StatementViewController?
    var presenterMock: StatementPresenterMock?

    override func setUpWithError() throws {
        presenterMock = StatementPresenterMock()
        sut = StatementViewController(presenter: presenterMock!)
    }

    func testNumberOfSections_ShouldCallPresenterNumberOfDatesAndReturnOne() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        let presenter = try XCTUnwrap(presenterMock)
        
        // Then
        let numberOfSections = sut.numberOfSections(in: .init())
        XCTAssertEqual(numberOfSections, 1)
        XCTAssertEqual(presenter.calledMethods, [.numberOfDates])
    }
    
    func testTableViewTitleForHeaderInSection_ShouldCallPresenterStringForDateAndReturnDateString() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        let presenter = try XCTUnwrap(presenterMock)
        
        // Then
        let title = sut.tableView(.init(), titleForHeaderInSection: 0)
        XCTAssertEqual(title, "01/08/2022")
        XCTAssertEqual(presenter.intToBeSet, 0)
        XCTAssertEqual(presenter.calledMethods, [.stringForDate])
    }

    func testNumberOfRowsInSection_ShouldCallPresenterNumberOfTransactionsAndReturnOne() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        let presenter = try XCTUnwrap(presenterMock)
        
        // Then
        let numberOfRows = sut.tableView(.init(), numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, 1)
        XCTAssertEqual(presenter.intToBeSet, 0)
        XCTAssertEqual(presenter.calledMethods, [.numberOfTransactions])
    }

    func testCellForRowAtIndexPath_ShouldCallPresenterGetTransactionInfoAndReturnCellWithExpectedData() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        let presenter = try XCTUnwrap(presenterMock)
        let indexPath = IndexPath(row: 0, section: 0)
        
        // Then
        let cell = sut.tableView(.init(), cellForRowAt: indexPath)
        XCTAssertEqual(presenter.indexPathToBeSet, indexPath)
        XCTAssertEqual(presenter.calledMethods, [.transactionInfo])
        XCTAssertEqual(cell.textLabel?.text, "name")
        XCTAssertEqual(cell.detailTextLabel?.text, "$0.00")
    }
    
    func testDeleteCell_ShouldCallPresenterMethodsRelatedToRemovalAndValuesUpdate() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        let presenter = try XCTUnwrap(presenterMock)
        let indexPath = IndexPath(row: 0, section: 0)

        // Then
        sut.tableView(.init(), commit: .delete, forRowAt: indexPath)
        XCTAssertEqual(presenter.intToBeSet, 0)
        XCTAssertEqual(presenter.indexPathToBeSet, indexPath)
        XCTAssertEqual(presenter.calledMethods, [.removeTransaction, .removeSectionIfNeeded, .totalExpenses, .totalIncome, .balance, .balanceProgress])
    }
    
    func testDidAdd_ShouldCallPresenterMethodsRelatedToAdditionAndValuesUpdate() throws {
        // Given
        let sut = try XCTUnwrap(sut)
        let presenter = try XCTUnwrap(presenterMock)
        let transaction = StatementModel.Transaction(type: .expense, name: "name", amount: 1.0)
        
        // Then
        sut.didAdd(transaction: transaction)
        XCTAssertEqual(presenter.transactionToBeSet?.type, .expense)
        XCTAssertEqual(presenter.transactionToBeSet?.name, "name")
        XCTAssertEqual(presenter.transactionToBeSet?.amount, 1.0)
        XCTAssertEqual(presenter.boolToBeSet, false)
        XCTAssertEqual(presenter.calledMethods, [.shouldAddNewSection, .addTransaction, .totalExpenses, .totalIncome, .balance, .balanceProgress])
    }
}
