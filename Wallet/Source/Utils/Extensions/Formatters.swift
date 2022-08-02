//
//  NumberFormatter+Extensions.swift
//  Wallet
//
//  Created by Pedro Veloso on 24/07/22.
//

import Foundation

extension Date {
    var asString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: self)
    }
}

extension Decimal {
    var asCurrency: String {
        let formatter = NumberFormatter()
        formatter.locale = .init(identifier: "en_US")
        
        let amount = formatter.number(from: self.description) ?? .init(value: 0.0)
        
        formatter.currencySymbol = "$"
        formatter.numberStyle = .currency
        
        return formatter.string(from: amount) ?? "0"
    }
}
