//
//  StatementViewController.swift
//  Wallet
//
//  Created by Pedro Veloso on 23/07/22.
//

import UIKit

class StatementViewController: UIViewController {
    // MARK: - UI Components
    private let financeInfoCardView = FinanceInfoCardView()
    private lazy var transactionsTableView = TransactionsTableView(parent: self)
    
    // MARK: - Properties
    private var presenter = StatementPresenter()

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
    }
    
    // MARK: - Private functions
    private func updateFinanceInfoCardView() {
        financeInfoCardView.set(expenses: presenter.totalExpenses.asCurrency)
        financeInfoCardView.set(income: presenter.totalIncome.asCurrency)
        financeInfoCardView.set(balance: presenter.balance.asCurrency)
        financeInfoCardView.set(progress: presenter.balanceProgress)
    }
}

// MARK: - View codable methods
extension StatementViewController: ViewCodable {
    func buildHierarchy() {
        view.addSubview(financeInfoCardView)
        view.addSubview(transactionsTableView)
    }
    
    func buildConstraints() {
        financeInfoCardView
            .top(to: view.safeAreaLayoutGuide.topAnchor, constant: 24.0)
            .horizontals(to: view, constant: 24.0)
        
        transactionsTableView
            .top(to: financeInfoCardView.bottomAnchor, constant: 24.0)
            .horizontals(to: view, constant: 24.0)
            .bottom(to: view.safeAreaLayoutGuide.bottomAnchor, constant: 24.0, makeLessThanOrEqual: true)
    }
    
    func buildAdditionalConfigurations() {
        view.backgroundColor = .systemBackground
        updateFinanceInfoCardView()
    }    
}

// MARK: - Statement table view methods
extension StatementViewController: StatementTableViewProtocol {
    // MARK: - Section
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.models.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        presenter.models[section].date.asString
    }
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.models[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsTableView.cellID) ?? UITableViewCell(style: .value1, reuseIdentifier: TransactionsTableView.cellID)
        
        let transactionInfo = presenter.transactionInfo(for: indexPath)

        cell.textLabel?.text = transactionInfo.name
        cell.detailTextLabel?.text = transactionInfo.amount
        cell.selectionStyle = .none
        
        return cell
    }
    
    // MARK: - Deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.removeTransaction(indexPath: indexPath)

            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            if presenter.removeSectionIfNeeded(section: indexPath.section) {
                tableView.deleteSections(.init(integer: indexPath.section), with: .automatic)
            }

            transactionsTableView.invalidateIntrinsicContentSize()
            updateFinanceInfoCardView()
            tableView.endUpdates()
        }
    }
}
