//
//  ProfileViewController.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 21/06/2023.
//

import UIKit
import FirebaseAuth

protocol ProfileViewControllerDelegate: AnyObject {
    func resetSelectedIndex()
}

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var mainView = ProfileView(delegate: self)
    
    weak var delegate: ProfileViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = mainView.getEmailLabel(), let _ = mainView.getAvatarImage() {
            return
        } else {
            mainView.updateEmailLabel()
            loadAvatarImage()
        }
    }
    
    // MARK: - Private methods
    
    private func loadAvatarImage() {
        guard let email = UserDefaults.standard.string(forKey: "email") else { return }
        
        let safeEmail = email.replacing(".", with: "-").replacing("@", with: "-")
        
        guard let stringUrl = UserDefaults.standard.string(forKey: "\(safeEmail)AvatarImage"),
              let imageUrl = URL(string: stringUrl) else { return }
        
        let request = URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, error in
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.mainView.updateAvatarImage(image: image)
            }
        }
        
        request.resume()
    }
}

    // MARK: - ProfileViewDelegate

extension ProfileViewController: ProfileViewDelegate {
    
    func logoutButtonTapped() {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure that you want to log out?",
            preferredStyle: .actionSheet
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            do {
                try FirebaseAuth.Auth.auth().signOut()
            } catch {
                return
            }
            
            FavoritesStorage.shared.favoriteItems = []
            FavoritesStorage.shared.isFetched = false
            NotificationCenter.default.post(name: Notifications.favoritesListChanged, object: nil)
            
            self?.mainView.resetAvatarImage()
            self?.mainView.resetEmailLabel()
            self?.showLoginViewController()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
        
        present(alert, animated: true)
    }
    
    private func showLoginViewController() {
        let viewController = LoginViewController()
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.tintColor = .black
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    func myOrdersButtonTapped() {
        let viewController = OrdersListViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

    // MARK: - LoginViewControllerDelegate

extension ProfileViewController: LoginViewControllerDelegate {
    
    func resetSelectedIndex() {
        delegate?.resetSelectedIndex()
    }
}
