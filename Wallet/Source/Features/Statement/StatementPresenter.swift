//
//  StatementPresenter.swift
//  Wallet
//
//  Created by Pedro Veloso on 24/07/22.
//

import Foundation

protocol StatementPresenterProtocol: AnyObject {
    var totalExpenses: Decimal { get }
    var totalIncome: Decimal { get }
    var balance: Decimal { get }
    var balanceProgress: Float { get }
    var numberOfDates: Int { get }
    func stringForDate(_ index: Int) -> String
    func numberOfTransactions(for index: Int) -> Int
    func transactionInfo(for indexPath: IndexPath) -> (name: String, amount: String)
    func removeSectionIfNeeded(section: Int) -> Bool
    func removeTransaction(indexPath: IndexPath)
    func shouldAddNewSection(for transaction: StatementModel.Transaction) -> Bool
    func addTransaction(_ transaction: StatementModel.Transaction, isNewDate: Bool)
}

final class StatementPresenter {
    // MARK: - Properties
    private let datasource: DatasourceProtocol

    private(set) lazy var totalExpenses: Decimal = calculateTotalAmount(for: .expense)
    private(set) lazy var totalIncome: Decimal = calculateTotalAmount(for: .income)
    
    private(set) var models: [StatementModel] {
        didSet {
            totalIncome = calculateTotalAmount(for: .income)
            totalExpenses = calculateTotalAmount(for: .expense)

            datasource.saveStatementInfo(models)
        }
    }

    // MARK: - Init
    init(datasource: DatasourceProtocol) {
        self.datasource = datasource
        self.models = datasource.fetchStatementInfo()
    }
}

extension StatementPresenter: StatementPresenterProtocol {
    // MARK: - Computed variables
    var balance: Decimal {
        totalIncome - totalExpenses
    }
    
    var balanceProgress: Float {
        let number = NSDecimalNumber(decimal: totalExpenses / totalIncome)
        return totalExpenses.isZero ? .zero : number.floatValue
    }
    
    var numberOfDates: Int {
        models.count
    }
    
    // MARK: - Exposed methods
    func stringForDate(_ index: Int) -> String {
        models[index].date.asString
    }
    
    func numberOfTransactions(for index: Int) -> Int {
        models[index].transactions.count
    }
    
    func transactionInfo(for indexPath: IndexPath) -> (name: String, amount: String) {
        let transaction = models[indexPath.section].transactions[indexPath.row]
        var amount = transaction.amount.asCurrency

        if transaction.type == .expense {
            amount = "- \(amount)"
        }
        
        return (transaction.name, amount)
    }
    
    func removeSectionIfNeeded(section: Int) -> Bool {
        if models[section].transactions.isEmpty {
            models.remove(at: section)
            return true
        }

        return false
    }
    
    func removeTransaction(indexPath: IndexPath) {
        models[indexPath.section].transactions.remove(at: indexPath.row)
    }
    
    func shouldAddNewSection(for transaction: StatementModel.Transaction) -> Bool {
        guard let lastTransactionDate = models.first?.date,
              Calendar.current.isDate(Date(), inSameDayAs: lastTransactionDate) else {
            return true
        }
        
        return false
    }
    
    func addTransaction(_ transaction: StatementModel.Transaction, isNewDate: Bool) {
        isNewDate ? addNewStatementEntry(with: transaction) : addNewTransaction(transaction)
    }
}

// MARK: - Private methods
private extension StatementPresenter {
    func calculateTotalAmount(for type: StatementModel.Transaction.Category) -> Decimal {
        models
            .flatMap({ $0.transactions })
            .reduce(.zero, { partialResult, transaction in
                let isSameType = transaction.type == type
                let value = isSameType ? transaction.amount : .zero
                return partialResult + value
            })
    }
    
    func addNewStatementEntry(with transaction: StatementModel.Transaction) {
        let statement = StatementModel(date: Date(), transactions: [transaction])
        models.insert(statement, at: 0)
    }
    
    func addNewTransaction(_ transaction: StatementModel.Transaction) {
        if !models.isEmpty {
            models[0].transactions.insert(transaction, at: 0)
        }
    }
}
