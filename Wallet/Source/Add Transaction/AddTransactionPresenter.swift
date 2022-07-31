//
//  AddTransactionPresenter.swift
//  Wallet
//
//  Created by Pedro Veloso on 30/07/22.
//

import Foundation

final class AddTransactionPresenter {
    // MARK: - Properties
    private(set) var type: StatementModel.Transaction.Category?
    private(set) var description: String = ""
    private(set) var amount: Decimal = Double(0.0).toDecimal
 
    let availableTransactionTypes = StatementModel.Transaction.Category.allCases

    private let amountUnit: Decimal = 1.0

    // MARK: - Type related methods
    func changedType(with index: Int) -> String {
        let selectedType = availableTransactionTypes[index]

        type = selectedType

        return selectedType.rawValue.capitalized
    }
    
    // MARK: - Description related methods
    func changedDescription(with text: String) -> String {
        description = text
        
        return description
    }
    
    // MARK: - Amount related methods
    func increasedAmount() -> String {
        amount += amountUnit

        return formattedCurrencyToPresent()
    }

    func decreasedAmount() -> String {
        let newValue = amount - amountUnit

        amount = newValue > 0 ? newValue : 0.0

        return formattedCurrencyToPresent()
    }
    
    func changeAmountIfNeeded(with text: String) -> String {
        if let amountAsInt = amountAsInt(for: text) {
            let newValue = Double(amountAsInt)/100
            amount = newValue.toDecimal
        }

        return formattedCurrencyToPresent()
    }
    
    // MARK: - Form related methods
    func getTransactionModel() -> StatementModel.Transaction? {
        guard let type = type, !description.isEmpty, amount > 0  else {
            return nil
        }

        return .init(type: type, name: description, amount: amount)
    }
}

private extension AddTransactionPresenter {
    func amountAsInt(for text: String) -> Int? {
        var text = text
        text.removeAll(where: { !$0.isNumber })

        return Int(text)
    }
    
    func formattedCurrencyToPresent() -> String {
        return amount.asCurrency
    }
}

private extension Double {
    var toDecimal: Decimal {
        NSNumber(value: self).decimalValue
    }
}
