//
//  FinanceInfoCardView.swift
//  Wallet
//
//  Created by Pedro Veloso on 23/07/22.
//

import UIKit

class FinanceInfoCardView: UIView {
    // MARK: - Main content
    private lazy var contentVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            keyValueHStack,
            progressBar
        ])
        stack.axis = .vertical
        stack.spacing = 24.0
        
        return stack
    }()

    // MARK: - KeyValue Content
    private lazy var keyValueHStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            expensesView,
            divisor,
            incomeView,
            divisor,
            balanceView
        ])
        
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private let expensesView = KeyValueView()
    private let incomeView = KeyValueView()
    private let balanceView = KeyValueView()
    
    private var divisor: UIView {
        let view = UIView()
        view.backgroundColor = .separator
        view.width(1)
        return view
    }
    
    // MARK: - Progress content
    private let progressBar: UIProgressView = {
        let view =  UIProgressView(progressViewStyle: .bar)
        view.backgroundColor = .systemGray5
        view.clipsToBounds = true
        view.layer.cornerRadius = 4.0

        return view
    }()
    
    // MARK: - Inits
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        buildViewCode()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Exposed methods
    func set(expenses value: String) {
        expensesView.setValueLabel(with: value)
    }

    func set(income value: String) {
        incomeView.setValueLabel(with: value)
    }
    
    func set(balance value: String) {
        balanceView.setValueLabel(with: value)
    }
    
    func set(progress value: Float) {
        DispatchQueue.main.async {
            self.progressBar.setProgress(value, animated: true)
        }
    }
}

// MARK: - View codable methods
extension FinanceInfoCardView: ViewCodable {
    func buildHierarchy() {
        addSubview(contentVStack)
    }
    
    func buildConstraints() {
        contentVStack
            .top(to: topAnchor, constant: 24.0)
            .horizontals(to: self, constant: 32.0)
            .bottom(to: bottomAnchor, constant: 32.0)
        
        progressBar
            .height(8.0)
    }
    
    func buildAdditionalConfigurations() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false

        addCustomBorder()
        
        expensesView.setKeyLabel(with: Strings.expenses.rawValue)
        incomeView.setKeyLabel(with: Strings.income.rawValue)
        balanceView.setKeyLabel(with: Strings.balance.rawValue)
    }
}

// MARK: - Strings
private extension FinanceInfoCardView {
    // I would propably use SwiftGen in a "real" project.
    enum Strings: String {
        case expenses = "Expenses"
        case income = "Income"
        case balance = "Balance"
    }
}
