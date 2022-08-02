//
//  CustomFieldView.swift
//  Wallet
//
//  Created by Pedro Veloso on 25/07/22.
//

import UIKit

protocol CustomFieldView: UITextFieldDelegate {
    func didSelectUp(selector: CustomTextFieldView)
    func didSelectDown(selector: CustomTextFieldView)
}

final class CustomTextFieldView: UITextField {
    // MARK: - UI Elements
    var upSelector: UIButton {
        let button = UIButton()
        button.setImage(.init(systemName: "chevron.up"), for: .normal)
        button.addTarget(self, action: #selector(didSelectUp), for: .touchUpInside)
        
        button.accessibilityIdentifier = AccessibilityId.upSelector.rawValue
        
        return button
    }
    
    var downSelector: UIButton {
        let button = UIButton()
        button.setImage(.init(systemName: "chevron.down"), for: .normal)
        button.addTarget(self, action: #selector(didSelectDown), for: .touchUpInside)
        
        button.accessibilityIdentifier = AccessibilityId.downSelector.rawValue
        
        return button
    }
    
    // MARK: - Properties
    weak var customDelegate: CustomFieldView? {
        didSet {
            delegate = customDelegate
        }
    }
    
    var textEditingEnabled = true
    
    private let selector: SelectorType

    private let textInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 12.0)
    
    // MARK: - Overriden methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textInsets)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.rightViewRect(forBounds: bounds)
        return rect.inset(by: .init(top: 0.0, left: -8.0, bottom: 0.0, right: 8.0))
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.leftViewRect(forBounds: bounds)
        return rect.inset(by: .init(top: 0.0, left: 8.0, bottom: 0.0, right: -8.0))
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        textEditingEnabled
    }

    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        textEditingEnabled ? super.selectionRects(for: range) : []
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        textEditingEnabled ? super.caretRect(for: position) : .null
    }
    
    // MARK: - Inits
    init(selector: SelectorType, frame: CGRect = .zero) {
        self.selector = selector
        
        super.init(frame: .zero)
        
        buildViewCode()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View codable methods
extension CustomTextFieldView: ViewCodable {
    func buildHierarchy() {}
    
    func buildConstraints() {
        height(48.0)
    }
    
    func buildAdditionalConfigurations() {
        translatesAutoresizingMaskIntoConstraints = false
        addCustomBorder(radius: 8.0)
        
        buildSelectorsIfNeeded()
        addDefaultToolbar()
    }
}

// MARK: - Private methods
private extension CustomTextFieldView {
    func addDefaultToolbar() {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.sizeToFit()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let ok = UIBarButtonItem(title: Strings.okButton.rawValue, style: .done, target: self, action: #selector(dismissToolbar))
        
        toolbar.setItems([flexibleSpace, ok], animated: true)
        inputAccessoryView = toolbar
    }
    
    func buildSelectorsIfNeeded() {
        switch selector {
        case .single:
            rightView = downSelector
            rightViewMode = .always
            
        case .double:
            let vStack = UIStackView(arrangedSubviews: [upSelector, downSelector])
            vStack.axis = .vertical
            vStack.distribution = .fillEqually

            rightView = vStack
            rightViewMode = .always
        
        case .none:
            break
        }
    }
    
    @objc
    func didSelectUp() {
        customDelegate?.didSelectUp(selector: self)
    }
    
    @objc
    func didSelectDown() {
        customDelegate?.didSelectDown(selector: self)
    }
    
    @objc
    func dismissToolbar() {
        resignFirstResponder()
    }
}

// MARK: - Selector type
extension CustomTextFieldView {
    enum SelectorType {
        case none, single, double
    }
}

private extension CustomTextFieldView {
    // MARK: - Strings
    enum Strings: String {
        case okButton = "OK"
        case cancelButton = "Cancel"
    }
    
    // MARK: - Accessibility identifiers
    enum AccessibilityId: String {
        case upSelector
        case downSelector
    }
}
