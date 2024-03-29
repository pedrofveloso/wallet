//
//  StatementViewController.swift
//  Wallet
//
//  Created by Pedro Veloso on 23/07/22.
//

import UIKit

class StatementViewController: UIViewController {
    // MARK: - UI Components
    private let financeInfoCardView: FinanceInfoCardView = {
        let view = FinanceInfoCardView()
        
        view.accessibilityIdentifier = AccessibilityId.financialInfoCardView.rawValue
        
        return view
    }()

    private lazy var transactionsTableView: TransactionsTableView = {
        let view = TransactionsTableView(parent: self)
        
        view.accessibilityIdentifier = AccessibilityId.transactionTableView.rawValue
        
        return view
    }()
    
    private lazy var addTransactionButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        
        button.addTarget(self, action: #selector(openAddTransactionModal), for: .touchUpInside)
        
        button.accessibilityIdentifier = AccessibilityId.addTransactionButton.rawValue
        
        return button
    }()
    
    // MARK: - Properties
    private var presenter: StatementPresenterProtocol

    // MARK: - Inits
    init(presenter: StatementPresenterProtocol) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
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
    
    @objc
    private func openAddTransactionModal() {
        let viewController = AddTransactionViewController()
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overFullScreen
        viewController.delegate = self
        
        present(viewController, animated: true)
    }
}

// MARK: - View codable methods
extension StatementViewController: ViewCodable {
    func buildHierarchy() {
        view.addSubview(financeInfoCardView)
        view.addSubview(transactionsTableView)
        view.addSubview(addTransactionButton)
    }
    
    func buildConstraints() {
        financeInfoCardView
            .top(to: view.safeAreaLayoutGuide.topAnchor, constant: 24.0)
            .horizontals(to: view, constant: 24.0)
        
        transactionsTableView
            .top(to: financeInfoCardView.bottomAnchor, constant: 24.0)
            .horizontals(to: view, constant: 24.0)
            .bottom(to: view.safeAreaLayoutGuide.bottomAnchor, constant: 24.0, makeLessThanOrEqual: true)
        
        addTransactionButton
            .height(72.0)
            .width(72.0)
            .trailing(to: view.trailingAnchor, constant: 24.0)
            .bottom(to: view.safeAreaLayoutGuide.bottomAnchor, constant: 24.0)
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
        presenter.numberOfDates
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        presenter.stringForDate(section)
    }
    
    // MARK: - Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfTransactions(for: section)
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

            if presenter.removeSectionIfNeeded(section: indexPath.section) {
                tableView.deleteSections(.init(integer: indexPath.section), with: .automatic)
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)

            transactionsTableView.invalidateIntrinsicContentSize()
            updateFinanceInfoCardView()

            tableView.endUpdates()
        }
    }
}

// MARK: - Add transaction delegate methods
extension StatementViewController: AddTransactionDelegate {
    func didAdd(transaction: StatementModel.Transaction) {
        let isNewDate = presenter.shouldAddNewSection(for: transaction)
        presenter.addTransaction(transaction, isNewDate: isNewDate)
        
        transactionsTableView.tableView.beginUpdates()
        
        if isNewDate {
            transactionsTableView.tableView.insertSections(.init(integer: 0), with: .automatic)
        }

        transactionsTableView.tableView.insertRows(at: [.init(row: 0, section: 0)], with: .automatic)
        
        transactionsTableView.invalidateIntrinsicContentSize()
        updateFinanceInfoCardView()

        transactionsTableView.tableView.endUpdates()
    }
}

// MARK: - Accessibility identifiers
private extension StatementViewController {
    enum AccessibilityId: String {
        case financialInfoCardView
        case transactionTableView
        case addTransactionButton
    }
}
