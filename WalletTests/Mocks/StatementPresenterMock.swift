//
//  StatementPresenterMock.swift
//  WalletTests
//
//  Created by Pedro Veloso on 01/08/22.
//

import Foundation
@testable import Wallet

final class StatementPresenterMock: StatementPresenterProtocol {
    enum Method {
        case totalExpenses
        case totalIncome
        case balance
        case balanceProgress
        case numberOfDates
        case stringForDate
        case numberOfTransactions
        case transactionInfo
        case removeSectionIfNeeded
        case removeTransaction
        case shouldAddNewSection
        case addTransaction
    }
    
    var calledMethods = [Method]()
    
    var intToBeSet: Int?
    var indexPathToBeSet: IndexPath?
    var transactionToBeSet: StatementModel.Transaction?
    var boolToBeSet: Bool?
    
    var removeSectionIfNeededResultMock = false
    var shouldAddNewSectionResultMock = false

    var totalExpenses: Decimal {
        calledMethods.append(.totalExpenses)
        
        return 0.0
    }
    
    var totalIncome: Decimal {
        calledMethods.append(.totalIncome)
        
        return 0.0
    }
    
    var balance: Decimal {
        calledMethods.append(.balance)
        
        return 0.0
    }
    
    var balanceProgress: Float {
        calledMethods.append(.balanceProgress)
        
        return 0.0
    }
    
    var numberOfDates: Int {
        calledMethods.append(.numberOfDates)
        return 1
    }
    
    func stringForDate(_ index: Int) -> String {
        intToBeSet = index
        calledMethods.append(.stringForDate)
        
        return "01/08/2022"
    }
    
    func numberOfTransactions(for index: Int) -> Int {
        intToBeSet = index
        calledMethods.append(.numberOfTransactions)
        
        return 1
    }
    
    func transactionInfo(for indexPath: IndexPath) -> (name: String, amount: String) {
        indexPathToBeSet = indexPath
        calledMethods.append(.transactionInfo)
        return ("name", "$0.00")
    }
    
    func removeSectionIfNeeded(section: Int) -> Bool {
        intToBeSet = section
        calledMethods.append(.removeSectionIfNeeded)
        
        return removeSectionIfNeededResultMock
    }
    
    func removeTransaction(indexPath: IndexPath) {
        indexPathToBeSet = indexPath
        calledMethods.append(.removeTransaction)
    }
    
    func shouldAddNewSection(for transaction: StatementModel.Transaction) -> Bool {
        transactionToBeSet = transaction
        calledMethods.append(.shouldAddNewSection)
        
        return shouldAddNewSectionResultMock
    }
    
    func addTransaction(_ transaction: StatementModel.Transaction, isNewDate: Bool) {
        transactionToBeSet = transaction
        boolToBeSet = isNewDate
        calledMethods.append(.addTransaction)
    }
}
