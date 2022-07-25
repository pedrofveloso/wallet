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
        let amount = formatter.number(from: "\(self)") ?? .init(value: 0.0)
        
        formatter.numberStyle = .currency
        
        return formatter.string(from: amount) ?? "0"
    }
}
