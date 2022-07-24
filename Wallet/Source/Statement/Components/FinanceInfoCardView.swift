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
            hStack,
            progressBar
        ])
        stack.axis = .vertical
        stack.spacing = 24.0
        
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
    private let progressBar: UIProgressView = {
        let view =  UIProgressView(progressViewStyle: .bar)
        view.progress = 0.5
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
}

// MARK: - View codable methods
extension FinanceInfoCardView: ViewCodable {
    func buildHierarchy() {
        addSubview(contentVStack)
    }
    
    func buildConstraints() {
        contentVStack
            .edges(to: self, constant: 32)
        
        progressBar
            .height(8.0)
    }
    
    func buildAdditionalConfigurations() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false

        layer.borderColor = UIColor.separator.cgColor
        layer.borderWidth = 1.0
    }
}
