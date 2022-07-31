//
//  StatementModel.swift
//  Wallet
//
//  Created by Pedro Veloso on 24/07/22.
//

import Foundation

struct StatementModel {
    let date: Date
    var transactions: [Transaction]
}

extension StatementModel {
    struct Transaction {
        let type: Category
        let name: String
        let amount: Decimal
    }
}

extension StatementModel.Transaction {
    enum Category: String, CaseIterable {
        case expense, income
    }
}


