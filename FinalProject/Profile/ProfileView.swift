//
//  ProfileView.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 27/06/2023.
//

import UIKit
import FirebaseAuth

protocol ProfileViewDelegate: AnyObject {
    func logoutButtonTapped()
    func myOrdersButtonTapped()
}

final class ProfileView: UIView {
    
    // MARK: - Properties
    
    private let delegate: ProfileViewDelegate
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100
        imageView.backgroundColor = .systemBlue
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 12
        button.setTitle("Logout", for: .normal)
        return button
    }()
    
    private let myOrdersButton: UIButton = {
        let configuration = UIButton.Configuration.gray()
        let button = UIButton()
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.setTitle("My orders", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    // MARK: - Init
    
    init(delegate: ProfileViewDelegate) {
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        setupAvatarImageView()
        setupEmailLabel()
        setupLogoutButton()
        setupMyOrdersButton()
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
    
    private func setupEmailLabel() {
        addSubview(emailLabel)
        emailLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16).isActive = true
        emailLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    private func setupLogoutButton() {
        addSubview(logoutButton)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchDown)
        logoutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    private func setupMyOrdersButton() {
        addSubview(myOrdersButton)
        myOrdersButton.addTarget(self, action: #selector(myOrdersButtonTapped), for: .touchDown)
        myOrdersButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 16).isActive = true
        myOrdersButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        myOrdersButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        myOrdersButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    @objc
    private func logoutButtonTapped() {
        delegate.logoutButtonTapped()
    }
    
    @objc
    private func myOrdersButtonTapped() {
        delegate.myOrdersButtonTapped()
    }
    
    // MARK: - Methods
    
    func updateEmailLabel() {
        emailLabel.text = FirebaseAuth.Auth.auth().currentUser?.email
    }
    
    func resetEmailLabel() {
        emailLabel.text = ""
    }
    
    func getEmailLabel() -> String? {
        emailLabel.text
    }
    
    func updateAvatarImage(image: UIImage) {
        avatarImageView.image = image
    }
    
    func resetAvatarImage() {
        avatarImageView.image = nil 
    }
    
    func getAvatarImage() -> UIImage? {
        avatarImageView.image
    }
}
