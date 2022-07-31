//
//  Datasource.swift
//  Wallet
//
//  Created by Pedro Veloso on 31/07/22.
//

import Foundation

protocol DatasourceProtocol {
    func fetchStatementInfo() -> [StatementModel]
    func saveStatementInfo(_ models: [StatementModel])
}

final class Datasource {
    static let shared = Datasource()
    
    private let key = "ud-statement-info-key"
    
    private init() {}
}

extension Datasource: DatasourceProtocol {
    func fetchStatementInfo() -> [StatementModel] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        
        let object = try? JSONDecoder().decode([StatementModel].self, from: data)
        return object ?? []
    }
    
    func saveStatementInfo(_ models: [StatementModel]) {
        if let data = try? JSONEncoder().encode(models) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
