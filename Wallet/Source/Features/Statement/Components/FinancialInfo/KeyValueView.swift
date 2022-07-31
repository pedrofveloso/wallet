//
//  KeyValueView.swift
//  Wallet
//
//  Created by Pedro Veloso on 23/07/22.
//

import UIKit

class KeyValueView: UIView {
    // MARK: - Properties
    private let keyLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        return label
    }()
    
    private lazy var vStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [keyLabel, valueLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8.0
        return stack
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
    func setKeyLabel(with text: String) {
        keyLabel.text = text
    }
    
    func setValueLabel(with text: String) {
        valueLabel.text = text
    }
}

// MARK: - View codable methods
extension KeyValueView: ViewCodable {
    func buildHierarchy() {
        addSubview(vStack)
    }
    
    func buildConstraints() {
        vStack.edges(to: self, constant: 8)
    }
    
    func buildAdditionalConfigurations() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
    }
}
