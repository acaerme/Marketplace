//
//  MainTabBarController.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 11/05/2023.
//

import UIKit
import FirebaseAuth

final class MainTabBarController: UITabBarController {
    
    private var productListNavigationController: UINavigationController {
        let viewController = ProductListViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.tintColor = .black
        navigationController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        return navigationController
    }
    
    private var favoritesNavigationController: UINavigationController {
        let viewController = FavoritesViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.tintColor = .black
        navigationController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "suit.heart"),
            selectedImage: UIImage(systemName: "suit.heart.fill")
        )
        return navigationController
    }
    
    private var profileNavigationController: UIViewController {
        let viewController = ProfileViewController()
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.tintColor = .black
        navigationController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        return navigationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [productListNavigationController, favoritesNavigationController, profileNavigationController]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showLoginViewControllerIfNeeded()
    }
    
    private func showLoginViewControllerIfNeeded() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let viewController = LoginViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.navigationBar.tintColor = .black
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
        }
    }
}

extension MainTabBarController: ProfileViewControllerDelegate {
    
    func resetSelectedIndex() {
        selectedIndex = 0
    }
}
