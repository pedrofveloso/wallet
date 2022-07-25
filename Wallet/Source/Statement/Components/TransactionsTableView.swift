//
//  TransactionsTableView.swift
//  Wallet
//
//  Created by Pedro Veloso on 24/07/22.
//

import UIKit

typealias StatementTableViewProtocol = UITableViewDataSource & UITableViewDelegate

class TransactionsTableView: UIView {
    static let cellID = "statementCellIdentifier"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.dataSource = parent
        tableView.delegate = parent
        
        return tableView
    }()
    
    private weak var parent: StatementTableViewProtocol?
    
    init(parent: StatementTableViewProtocol, frame: CGRect = .zero) {
        super.init(frame: frame)
        self.parent = parent
        buildViewCode()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        tableView.contentSize
    }
}

extension TransactionsTableView: ViewCodable {
    func buildHierarchy() {
        addSubview(tableView)
    }
    
    func buildConstraints() {
        tableView
            .edges(to: self)
    }
    
    func buildAdditionalConfigurations() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        
        addCustomBorder()
        
    }
}
