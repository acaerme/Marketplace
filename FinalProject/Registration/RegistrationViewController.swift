//
//  RegistrationViewController.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 20/06/2023.
//

import UIKit
import FirebaseAuth

protocol RegistrationViewControllerDelegate: AnyObject {
    func resetSelectedIndex()
}

final class RegistrationViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var mainView = RegistrationView(delegate: self)
    
    weak var delegate: RegistrationViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Registration"

        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarImageViewTapped))
        mainView.addTapGestureRecognizer(tapGesture: tapGesture)
    }
    
    // MARK: - Methods
    
    @objc
    private func avatarImageViewTapped() {
        let alert = UIAlertController(
            title: "How would you like to set photo?",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let galleryAction = UIAlertAction(title: "Choose from gallery", style: .default) { [weak self] _ in
            self?.showGallery()
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.showCamera()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func showGallery() {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        pickerController.delegate = self
        present(pickerController, animated: true)
    }
    
    private func showCamera() {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .camera
        pickerController.allowsEditing = true
        pickerController.delegate = self
        present(pickerController, animated: true)
    }
}

    // MARK: - RegistrationViewDelegate

extension RegistrationViewController: RegistrationViewDelegate {
    
    func shouldEnableButton(emailText: String?, passwordText: String?) {
        guard let emailText = emailText, let passwordText = passwordText else {
            mainView.updateRegisterButton(enable: false)
            return
        }
        
        let condition = !emailText.isEmpty && passwordText.count >= 6
        
        mainView.updateRegisterButton(enable: condition)
    }
    
    func registerButtonTapped(emailText: String?, passwordText: String?) {
        guard let emailText = emailText, let passwordText = passwordText else { return }
                
        FirebaseAuth.Auth.auth().createUser(withEmail: emailText, password: passwordText) { [weak self] result, error in
            guard let _ = result, error == nil else { return }
            
            let safeEmail = emailText.replacing(".", with: "-").replacing("@", with: "-")
    
            StorageManager.shared.uploadAvatarImage(data: self?.mainView.getAvatarImagePngData(), email: safeEmail) {
                imageUrl in
                guard let imageUrl = imageUrl else { return }
                                
                UserDefaults.standard.set(imageUrl, forKey: "\(safeEmail)AvatarImage")
                UserDefaults.standard.set(emailText, forKey: "email")
                
                self?.delegate?.resetSelectedIndex()
                self?.navigationController?.dismiss(animated: true)
            }
        }
    }
}

    // MARK: - UIImagePickerControllerDelegate

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        mainView.updateAvatarImageView(image: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
