//
//  KeyValueView.swift
//  Wallet
//
//  Created by Pedro Veloso on 23/07/22.
//

import UIKit

class KeyValueView: UIView {
    private let keyLabel = UILabel()
    private let valueLabel: UILabel = {
        let label = UILabel()
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
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        //FIXME: Remove fixed values
        keyLabel.text = "Key"
        valueLabel.text = "$1000123112254121231230"

        buildViewCode()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setKeyLabel(with text: String) {
        keyLabel.text = text
    }
    
    func setValueLabel(with text: String) {
        valueLabel.text = text
    }
}

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
