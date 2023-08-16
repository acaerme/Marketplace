//
//  LoginView.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 20/06/2023.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func shouldEnableButton(emailText: String?, passwordText: String?)
    func loginButtonTapped(emailText: String?, passwordText: String?)
    func registerButtonTapped()
}

final class LoginView: UIView {
    
    // MARK: - Properties
    
    private let delegate: LoginViewDelegate
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.placeholder = "Email"
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.placeholder = "Password"
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true 
        return textField
    }()
    
    private let loginButton: UIButton = {
        let configuration = UIButton.Configuration.plain()
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.setTitle("Login", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private let registerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Don't have an account?"
        return label
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init
    
    init(delegate: LoginViewDelegate) {
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        setupEmailTextField()
        setupPasswordTextField()
        setupLoginButton()
        setupRegisterLabel()
        setupRegisterButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupEmailTextField() {
        addSubview(emailTextField)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 120).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        emailTextField.setIcon("envelope.fill")
    }
    
    private func setupPasswordTextField() {
        addSubview(passwordTextField)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        passwordTextField.setIcon("lock.fill")
    }
    
    private func setupLoginButton() {
        addSubview(loginButton)
        updateLoginButton(enable: false)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchDown)
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 8).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: -8).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    private func setupRegisterLabel() {
        addSubview(registerLabel)
        registerLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 64).isActive = true
        registerLabel.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor, constant: 48).isActive = true
    }
    
    private func setupRegisterButton() {
        addSubview(registerButton)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchDown)
        registerButton.centerYAnchor.constraint(equalTo: registerLabel.centerYAnchor).isActive = true
        registerButton.leadingAnchor.constraint(equalTo: registerLabel.trailingAnchor, constant: 4).isActive = true
        
        let attributedString = NSAttributedString(
            string: "Create one now!",
            attributes: [
                .foregroundColor: UIColor.systemBlue
            ]
        )
        
        registerButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    func updateLoginButton(enable: Bool) {
        if enable {
            loginButton.isEnabled = true
            loginButton.alpha = 1
        } else {
            loginButton.isEnabled = false 
            loginButton.alpha = 0.5
        }
    }
    
    @objc
    private func textFieldDidChange() {
        delegate.shouldEnableButton(emailText: emailTextField.text, passwordText: passwordTextField.text)
    }
    
    @objc
    private func loginButtonTapped() {
        delegate.loginButtonTapped(emailText: emailTextField.text, passwordText: passwordTextField.text)
    }
    
    @objc
    private func registerButtonTapped() {
        delegate.registerButtonTapped()
    }
}
