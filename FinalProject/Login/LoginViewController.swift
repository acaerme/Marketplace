//
//  LoginViewController.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 20/06/2023.
//

import UIKit
import FirebaseAuth

protocol LoginViewControllerDelegate: AnyObject {
    func resetSelectedIndex()
}

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var mainView = LoginView(delegate: self)
    
    weak var delegate: LoginViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login"
        
        view.backgroundColor = .white
    }
}


    // MARK: - LoginViewDelegate

extension LoginViewController: LoginViewDelegate {
    
    func shouldEnableButton(emailText: String?, passwordText: String?) {
        guard let emailText = emailText, let passwordText = passwordText else {
            mainView.updateLoginButton(enable: false)
            return
        }
        
        let condition = !emailText.isEmpty && passwordText.count >= 6
        
        mainView.updateLoginButton(enable: condition)
    }
    
    func loginButtonTapped(emailText: String?, passwordText: String?) {
        guard let emailText = emailText, let passwordText = passwordText else { return }
                        
        FirebaseAuth.Auth.auth().signIn(withEmail: emailText, password: passwordText) { [weak self] result, error in
            guard let _ = result, error == nil else { return }
            
            UserDefaults.standard.set(emailText, forKey: "email")
            
            self?.delegate?.resetSelectedIndex()
            self?.navigationController?.dismiss(animated: true)
        }
    }
    
    func registerButtonTapped() {
        let viewController = RegistrationViewController()
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension LoginViewController: RegistrationViewControllerDelegate {
    
    func resetSelectedIndex() {
        delegate?.resetSelectedIndex()
    }
}
