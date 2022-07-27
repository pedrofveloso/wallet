//
//  AddTransactionViewController.swift
//  Wallet
//
//  Created by Pedro Veloso on 25/07/22.
//

import UIKit

class AddTransactionViewController: UIViewController {
    // MARK: - UI components
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.addCustomBorder(radius: .zero)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.title.rawValue
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private lazy var transactionTypeSelector: CustomTextFieldView = {
        let view = CustomTextFieldView(selector: .single)
        view.text = Strings.defaultTransactionSelection.rawValue
        view.textEditingEnabled = false

        view.inputView = transactionTypePickerView
        
        view.customDelegate = self
        
        return view
    }()
    
    private let descriptionTextField: CustomTextFieldView = {
        let textField = CustomTextFieldView(selector: .none)
        textField.placeholder = Strings.textFieldPlaceholder.rawValue
        return textField
    }()

    private lazy var amountSelector: CustomTextFieldView = {
        let view = CustomTextFieldView(selector: .double)
        
        let currencyLabel = UILabel()
        currencyLabel.text = Strings.currencySymbol.rawValue
        
        view.leftViewMode = .always
        view.leftView = currencyLabel
        
        view.customDelegate = self
        view.keyboardType = .decimalPad
        return view
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.submitButtonTile.rawValue, for: .normal)
        button.backgroundColor = .systemBlue
        button.addCustomBorder(radius: 8.0)
        
        button.addTarget(self, action: #selector(didSubmit), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var transactionTypePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self

        return pickerView
    }()
    
    // MARK: - Inits
    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        buildViewCode()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overriden methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        
        if touch?.view != contentView && !transactionTypeSelector.isFirstResponder {
            self.dismiss(animated: true)
        }
        
        if transactionTypeSelector.isFirstResponder {
            transactionTypeSelector.resignFirstResponder()
        }
    }
}

// MARK: - Private methods
private extension AddTransactionViewController {
    @objc
    func didSubmit() {
        print("did hit button")
        self.dismiss(animated: true)
    }
    
    func shouldChangeAmountSelectorValue(text: String) -> Bool {
        if let textAsInt = Int(text.replacingOccurrences(of: ".", with: "")) {
            amountSelector.text = "\(Double(textAsInt)/100)"
        }

        return false
    }
}

// MARK: - View codable methods
extension AddTransactionViewController: ViewCodable {
    func buildHierarchy() {
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(transactionTypeSelector)
        contentView.addSubview(descriptionTextField)
        contentView.addSubview(amountSelector)
        contentView.addSubview(submitButton)
    }
    
    func buildConstraints() {
        contentView.horizontals(to: view, constant: 16.0)
        contentView.centerY(to: view.centerYAnchor)
        
        titleLabel
            .top(to: contentView.topAnchor, constant: 16.0)
            .horizontals(to: contentView)
        
        transactionTypeSelector
            .top(to: titleLabel.bottomAnchor, constant: 16.0)
            .horizontals(to: contentView, constant: 48.0)
        
        descriptionTextField
            .top(to: transactionTypeSelector.bottomAnchor, constant: 16.0)
            .horizontals(to: contentView, constant: 48.0)
        
        amountSelector
            .top(to: descriptionTextField.bottomAnchor, constant: 16.0)
            .width(128.0)
            .centerX(to: contentView.centerXAnchor)
        
        submitButton
            .top(to: amountSelector.bottomAnchor, constant: 16.0)
            .height(48.0)
            .width(200.0)
            .centerX(to: contentView.centerXAnchor)
            .bottom(to: contentView.bottomAnchor, constant: 16.0)
    }
    
    func buildAdditionalConfigurations() {
        view.backgroundColor = .black.withAlphaComponent(0.25)
    }
}

// MARK: - UIPickerView datasource and delegate methods
extension AddTransactionViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // FIXME: Send to view model
        StatementModel.Transaction.Category.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let categories = StatementModel.Transaction.Category.allCases
        
        return categories[row].rawValue.capitalized
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let categories = StatementModel.Transaction.Category.allCases
        
        transactionTypeSelector.text = categories[row].rawValue.capitalized
        transactionTypeSelector.resignFirstResponder()
    }
}

// MARK: - Custom text field view delegate methods
extension AddTransactionViewController: CustomFieldView {
    func didSelectUp(selector: CustomTextFieldView) {
        // TODO: Use on amount selector
    }
    
    func didSelectDown(selector: CustomTextFieldView) {
        if selector == transactionTypeSelector {
            print("Show transaction type action sheet")
        } else {
            // TODO: Use on amount selector
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var text = textField.text ?? ""
        
        if let nsRange = Range.init(range, in: text) {
            text.replaceSubrange(nsRange, with: string)
        }
        
        if textField == transactionTypeSelector {
            return false
            
        }else if textField == amountSelector {
            return shouldChangeAmountSelectorValue(text: text)
        
        } else {
            return true

        }
    }
}

// MARK: - Strings
private extension AddTransactionViewController {
    enum Strings: String {
        case title = "Add Transaction"
        case defaultTransactionSelection = "Transaction Type"
        case textFieldPlaceholder = "Transaction Description"
        case submitButtonTile = "Add"
        case currencySymbol = "$"
    }
}
