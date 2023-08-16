//
//  CheckoutView.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 08/06/2023.
//

import UIKit

protocol CheckoutViewDelegate: AnyObject {
    func shouldEnableButton(nameText: String?, numberText: String?)
    func checkoutButtonTapped()
}

final class CheckoutView: UIView {
    
    // MARK: - Properties
    
    private let dataSource: UITableViewDataSource
    private let delegate: CheckoutViewDelegate
    
    var total: String? {
        didSet {
            guard let total = total else { return }
            totalValueLabel.text = "$" + String(total)
        }
    }
    
    // MARK: - UI Elements
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.placeholder = "Name"
        return textField
    }()
    
    private let numberTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.placeholder = "Phone number"
        return textField
    }()
    
    private let checkoutButton: UIButton = {
        let configuration = UIButton.Configuration.plain()
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.setTitle("Chekout", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 28)
        label.text = "Total:"
        return label
    }()
    
    private let totalValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 28)
        return label
    }()
    
    private let checkoutProductsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 180
        return tableView
    }()
    
    // MARK: - Init
    
    init(dataSource: UITableViewDataSource, delegate: CheckoutViewDelegate) {
        self.dataSource = dataSource
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        setupNameTextField()
        setupNumberTextField()
        setupCheckoutButton()
        setupTotalLabel()
        setupTotalValueLabel()
        setupCheckoutProductsTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupNameTextField() {
        addSubview(nameTextField)
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        nameTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        nameTextField.setIcon("person.fill")
    }
    
    private func setupNumberTextField() {
        addSubview(numberTextField)
        numberTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        numberTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8).isActive = true
        numberTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor).isActive = true
        numberTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor).isActive = true
        numberTextField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        numberTextField.setIcon("phone.fill")
    }
    
    private func setupCheckoutProductsTableView() {
        addSubview(checkoutProductsTableView)
        checkoutProductsTableView.dataSource = dataSource
        checkoutProductsTableView.register(CheckoutTableViewCell.self, forCellReuseIdentifier: CheckoutTableViewCell.reuseId)
        checkoutProductsTableView.topAnchor.constraint(equalTo: numberTextField.bottomAnchor, constant: 8).isActive = true
        checkoutProductsTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        checkoutProductsTableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        checkoutProductsTableView.bottomAnchor.constraint(equalTo: totalLabel.topAnchor, constant: -12).isActive = true
    }

    private func setupTotalLabel() {
        addSubview(totalLabel)
        totalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = true
        totalLabel.bottomAnchor.constraint(equalTo: checkoutButton.topAnchor, constant: -12).isActive = true
    }
    
    private func setupTotalValueLabel() {
        addSubview(totalValueLabel)
        totalValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = true
        totalValueLabel.bottomAnchor.constraint(equalTo: totalLabel.bottomAnchor).isActive = true
    }
    
    private func setupCheckoutButton() {
        addSubview(checkoutButton)
        updateCheckoutButton(enable: false)
        checkoutButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchDown)
        checkoutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        checkoutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        checkoutButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        checkoutButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    func updateCheckoutButton(enable: Bool) {
        if enable {
            checkoutButton.isEnabled = true
            checkoutButton.alpha = 1
        } else {
            checkoutButton.isEnabled = false
            checkoutButton.alpha = 0.5
        }
    }
    
    @objc
    private func textFieldDidChange() {
        delegate.shouldEnableButton(nameText: nameTextField.text, numberText: numberTextField.text)
    }
    
    @objc
    private func checkoutButtonTapped() {
        delegate.checkoutButtonTapped()
    }
    
    func getUserName() -> String? {
        nameTextField.text
    }
    
    func getUserNumbaer() -> String? {
        numberTextField.text
    }
}
    
    // MARK: - Extension UITextField

extension UITextField {
    
    func setIcon(_ image: String) {
        let iconImageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        iconImageView.image = UIImage(systemName: image)
        iconImageView.tintColor = .lightGray
        
        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
        iconContainerView.addSubview(iconImageView)
        
        leftView = iconContainerView
        leftViewMode = .always
    }
}

