//
//  ViewCodable.swift
//  Wallet
//
//  Created by Pedro Veloso on 23/07/22.
//

import Foundation

protocol ViewCodable {
    func buildViewCode()
    func buildHierarchy()
    func buildConstraints()
    func buildAdditionalConfigurations()
}

extension ViewCodable {
    func buildViewCode() {
        buildHierarchy()
        buildConstraints()
        buildAdditionalConfigurations()
    }
}

