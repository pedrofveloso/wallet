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
            hStack
            // progress
        ])
        return stack
    }()

    // MARK: - KeyValue Content
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            expensesView,
            divisor,
            incomesView,
            divisor,
            balanceView
        ])
        
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private let expensesView = KeyValueView()
    private let incomesView = KeyValueView()
    private let balanceView = KeyValueView()
    
    private var divisor: UIView {
        let view = UIView()
        view.backgroundColor = .separator
        view.width(1)
        return view
    }
    
    // MARK: - Progress content
    
    // MARK: - Inits
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        buildViewCode()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View codable methods
extension FinanceInfoCardView: ViewCodable {
    func buildHierarchy() {
        addSubview(contentVStack)
    }
    
    func buildConstraints() {
        contentVStack
            .verticals(to: self, constant: 32)
            .horizontals(to: self, constant: 16)
    }
    
    func buildAdditionalConfigurations() {
        translatesAutoresizingMaskIntoConstraints = false

        layer.borderColor = UIColor.separator.cgColor
        layer.borderWidth = 1.0
    }
}
