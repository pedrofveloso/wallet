//
//  DatasourceMock.swift
//  WalletTests
//
//  Created by Pedro Veloso on 31/07/22.
//

import Foundation
@testable import Wallet

final class DatasourceMock: DatasourceProtocol {
    enum Method {
        case fetchStatementInfo
        case saveStatementInfo
    }
    
    var calledMethods = [Method]()
    
    var modelsToBeSet: [StatementModel]?
    
    var statementInfoMockResult: [StatementModel] = []
    
    func fetchStatementInfo() -> [StatementModel] {
        calledMethods.append(.fetchStatementInfo)
        
        return statementInfoMockResult
    }
    
    func saveStatementInfo(_ models: [StatementModel]) {
        modelsToBeSet = models
        
        calledMethods.append(.saveStatementInfo)
    }
}
