//
//  AddTransactionViewController.swift
//  Wallet
//
//  Created by Pedro Veloso on 25/07/22.
//

import UIKit

protocol AddTransactionDelegate: AnyObject {
    func didAdd(transaction: StatementModel.Transaction)
}

class AddTransactionViewController: UIViewController {
    // MARK: - UI components
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.addCustomBorder(radius: .zero)

        view.accessibilityIdentifier = AccessibilityId.contentView.rawValue
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.title.rawValue
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title3)
        
        label.accessibilityIdentifier = AccessibilityId.titleLabel.rawValue
        
        return label
    }()
    
    private(set) lazy var transactionTypeSelector: CustomTextFieldView = {
        let view = CustomTextFieldView(selector: .single)
        view.text = Strings.defaultTransactionSelection.rawValue
        view.inputView = transactionTypePickerView
        view.textEditingEnabled = false
        view.customDelegate = self
        
        view.addTarget(self, action: #selector(didChangeTransactionTypeSelector), for: .editingDidEnd)
        
        view.accessibilityIdentifier = AccessibilityId.transactionTypeSelector.rawValue
        
        return view
    }()
    
    private(set) lazy var descriptionTextField: CustomTextFieldView = {
        let textField = CustomTextFieldView(selector: .none)
        textField.placeholder = Strings.textFieldPlaceholder.rawValue
        textField.customDelegate = self
        
        textField.addTarget(self, action: #selector(didChangeDescriptionTextField), for: .editingChanged)
        
        textField.accessibilityIdentifier = AccessibilityId.descriptionTextField.rawValue

        return textField
    }()

    private(set) lazy var amountSelector: CustomTextFieldView = {
        let view = CustomTextFieldView(selector: .double)
        view.text = Strings.amountSelectorInitialValue.rawValue
        view.textAlignment = .left
        view.keyboardType = .numberPad
        view.customDelegate = self
        
        view.addTarget(self, action: #selector(didChangeAmountSelectorValue), for: .editingChanged)
        
        view.accessibilityIdentifier = AccessibilityId.amountSelector.rawValue
        
        return view
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.submitButtonTile.rawValue, for: .normal)
        button.isEnabled = false
        button.addCustomBorder(radius: 8.0)
        
        button.addTarget(self, action: #selector(didSubmit), for: .touchUpInside)
        
        button.accessibilityIdentifier = AccessibilityId.submitButton.rawValue
        
        return button
    }()
    
    private lazy var transactionTypePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self

        pickerView.accessibilityIdentifier = AccessibilityId.transactionTypePickerView.rawValue
        
        return pickerView
    }()
    
    // MARK: - Properties
    private var presenter: AddTransactionPresenterProtocol
    weak var delegate: AddTransactionDelegate?
    
    // MARK: - Inits
    init(presenter: AddTransactionPresenterProtocol = AddTransactionPresenter()) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        buildViewCode()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overriden methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        
        let hasSomeFirstResponder = transactionTypeSelector.isFirstResponder || descriptionTextField.isFirstResponder || amountSelector.isFirstResponder
        
        if touch?.view != contentView && !hasSomeFirstResponder {
            self.dismiss(animated: true)
        }
    }
}

// MARK: - Private methods
private extension AddTransactionViewController {
    // MARK: Text fields change action methods
    @objc
    func didChangeTransactionTypeSelector() {
        let selectedIndex = transactionTypePickerView.selectedRow(inComponent: 0)
        transactionTypeSelector.text = presenter.changedType(with: selectedIndex)

        validateForm()
    }

    @objc
    func didChangeDescriptionTextField(_ textField: UITextField) {
        descriptionTextField.text = presenter.changedDescription(with: textField.text ?? "")
        
        validateForm()
    }
    
    @objc
    func didChangeAmountSelectorValue(_ textField: UITextField) {
        amountSelector.text = presenter.changeAmountIfNeeded(with: textField.text ?? "")
        
        validateForm()
    }
    
    // MARK: Form submission methods
    func validateForm() {
        let isValid = presenter.getTransactionModel() != nil
        
        if isValid {
            submitButton.backgroundColor = .systemBlue
        } else {
            submitButton.backgroundColor = .systemGray4
        }
        
        submitButton.isEnabled = isValid
    }

    @objc
    func didSubmit() {
        guard let transaction = presenter.getTransactionModel() else {
            return
        }

        delegate?.didAdd(transaction: transaction)
        self.dismiss(animated: true)
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
            .width(144.0)
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
        validateForm()
    }
}

// MARK: - UIPickerView datasource and delegate methods
extension AddTransactionViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        presenter.availableTransactionTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        presenter.availableTransactionTypes[row].rawValue.capitalized
    }
}

// MARK: - Custom text field view delegate methods
extension AddTransactionViewController: CustomFieldView {
    func didSelectUp(selector: CustomTextFieldView) {
        if selector == amountSelector {
            selector.text = presenter.increasedAmount()
            validateForm()
        }
    }
    
    func didSelectDown(selector: CustomTextFieldView) {
        if selector == transactionTypeSelector {
            selector.becomeFirstResponder()

        } else if selector == amountSelector {
            selector.text = presenter.decreasedAmount()
            validateForm()
        }
    }
}

private extension AddTransactionViewController {
    // MARK: - Strings
    enum Strings: String {
        case title = "Add Transaction"
        case defaultTransactionSelection = "Transaction Type"
        case textFieldPlaceholder = "Transaction Description"
        case submitButtonTile = "Add"
        case amountSelectorInitialValue = "$ 0,00"
    }
    
    // MARK: - Accessibility identifiers
    enum AccessibilityId: String {
        case contentView
        case titleLabel
        case transactionTypeSelector
        case descriptionTextField
        case amountSelector
        case submitButton
        case transactionTypePickerView
    }
}
