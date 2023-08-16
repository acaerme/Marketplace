//
//  RegistrationView.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 20/06/2023.
//

import UIKit

protocol RegistrationViewDelegate: AnyObject {
    func shouldEnableButton(emailText: String?, passwordText: String?)
    func registerButtonTapped(emailText: String?, passwordText: String?)
}

final class RegistrationView: UIView {
    
    // MARK: - Properties
    
    private let delegate: RegistrationViewDelegate
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100
        imageView.backgroundColor = .systemBlue
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
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
    
    private let registerButton: UIButton = {
        let configuration = UIButton.Configuration.plain()
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.setTitle("Register", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Init
    
    init(delegate: RegistrationViewDelegate) {
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        setupAvatarImageView()
        setupEmailTextField()
        setupPasswordTextField()
        setupRegisterButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupAvatarImageView() {
        addSubview(avatarImageView)
        avatarImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func setupEmailTextField() {
        addSubview(emailTextField)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 64).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        emailTextField.setIcon("envelope.fill")
    }
    
    private func setupPasswordTextField() {
        addSubview(passwordTextField)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        passwordTextField.setIcon("lock.fill")
    }
    
    private func setupRegisterButton() {
        addSubview(registerButton)
        updateRegisterButton(enable: false)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchDown)
        registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32).isActive = true
        registerButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 8).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: -8).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    func updateRegisterButton(enable: Bool) {
        if enable {
            registerButton.isEnabled = true
            registerButton.alpha = 1
        } else {
            registerButton.isEnabled = false
            registerButton.alpha = 0.5
        }
    }
    
    @objc
    private func textFieldDidChange() {
        delegate.shouldEnableButton(emailText: emailTextField.text, passwordText: passwordTextField.text)
    }
    
    @objc
    private func registerButtonTapped() {
        delegate.registerButtonTapped(emailText: emailTextField.text, passwordText: passwordTextField.text)
    }
    
    func addTapGestureRecognizer(tapGesture: UITapGestureRecognizer) {
        avatarImageView.addGestureRecognizer(tapGesture)
    }
    
    func updateAvatarImageView(image: UIImage) {
        avatarImageView.image = image
    }
    
    func getAvatarImagePngData() -> Data? {
        avatarImageView.image?.pngData()
    }
}
