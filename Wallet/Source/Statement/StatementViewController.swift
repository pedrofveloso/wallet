//
//  StatementViewController.swift
//  Wallet
//
//  Created by Pedro Veloso on 23/07/22.
//

import UIKit

class StatementViewController: UIViewController {
    // MARK: - UI Elements
    private let financeInfoCardView = FinanceInfoCardView()
    private lazy var statementTableView = StatementTableView(parent: self)
    
    // MARK: - Properties

    // MARK: - Inits
    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViewCode()
        
        financeInfoCardView.set(income: "$0")
        financeInfoCardView.set(expenses: "$0")
        financeInfoCardView.set(balance: "$0")
    }
}

// MARK: - View codable methods
extension StatementViewController: ViewCodable {
    func buildHierarchy() {
        view.addSubview(financeInfoCardView)
        view.addSubview(statementTableView)
    }
    
    func buildConstraints() {
        financeInfoCardView
            .top(to: view.safeAreaLayoutGuide.topAnchor, constant: 24.0)
            .horizontals(to: view, constant: 24.0)
        
        statementTableView
            .top(to: financeInfoCardView.bottomAnchor, constant: 24.0)
            .horizontals(to: view, constant: 24.0)
        
        statementTableView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func buildAdditionalConfigurations() {
        view.backgroundColor = .systemBackground
    }    
}

// MARK: - Statement table view methods
extension StatementViewController: StatementTableViewProtocol {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatementTableView.cellID) ?? UITableViewCell(style: .value1, reuseIdentifier: StatementTableView.cellID)
        
        cell.textLabel?.text = "Text"
        cell.detailTextLabel?.text = "\(indexPath.row)"
        cell.selectionStyle = .none
        
        return cell
    }
}
