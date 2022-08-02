//
//  AddTransactionPresenterMock.swift
//  WalletTests
//
//  Created by Pedro Veloso on 01/08/22.
//

import Foundation
@testable import Wallet

final class AddTransactionPresenterMock: AddTransactionPresenterProtocol {
    enum Method {
        case availableTransactionTypes
        case changedType
        case changedDescription
        case increasedAmount
        case decreasedAmount
        case changeAmountIfNeeded
        case getTransactionModel
    }
    
    var calledMethods = [Method]()
    
    var intToBeSet: Int?
    var stringToBeSet: String?
    
    var getTransacationResultMock: StatementModel.Transaction?
    
    var availableTransactionTypes: [StatementModel.Transaction.Category] {
        calledMethods.append(.availableTransactionTypes)
        return [.expense, .income]
    }
    
    func changedType(with index: Int) -> String {
        intToBeSet = index
        calledMethods.append(.changedType)
        
        return "type"
    }
    
    func changedDescription(with text: String) -> String {
        stringToBeSet = text
        calledMethods.append(.changedDescription)
        
        return "description"
    }
    
    func increasedAmount() -> String {
        calledMethods.append(.increasedAmount)
        
        return "$1.00"
    }
    
    func decreasedAmount() -> String {
        calledMethods.append(.decreasedAmount)
        
        return "$0.00"
    }
    
    func changeAmountIfNeeded(with text: String) -> String {
        stringToBeSet = text
        calledMethods.append(.changeAmountIfNeeded)
        
        return "$5.00"
    }
    
    func getTransactionModel() -> StatementModel.Transaction? {
        calledMethods.append(.getTransactionModel)

        return getTransacationResultMock
    }
}
