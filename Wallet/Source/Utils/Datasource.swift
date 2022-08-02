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
    
    private var instance: UserDefaults? = .standard
    
    private init() {
        if ProcessInfo.processInfo.arguments.contains("-runningUITests") {
            instance = .init(suiteName: "ui-testing")
            instance?.removeObject(forKey: key)
        }
    }
}

extension Datasource: DatasourceProtocol {
    func fetchStatementInfo() -> [StatementModel] {
        guard let data = instance?.data(forKey: key) else {
            return []
        }
        
        let object = try? JSONDecoder().decode([StatementModel].self, from: data)
        return object ?? []
    }
    
    func saveStatementInfo(_ models: [StatementModel]) {
        if let data = try? JSONEncoder().encode(models) {
            instance?.set(data, forKey: key)
        }
    }
}
