//
//  FavoritesViewController.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 26/05/2023.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
// MARK: - UI Elements
    
    private let favoritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 180
        return tableView
    }()
    
    private let proceedToCheckoutButton: UIButton = {
        let configuration = UIButton.Configuration.plain()
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.setTitle("Proceed to chekout", for: .normal)
        return button
    }()

// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites"
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateFavoritesPage),
            name: Notifications.favoritesListChanged,
            object: nil
        )
        
        setupFavoritesTableView()
        setupProceedToCheckoutButton()
    }
    
// MARK: - Private methods
    
    private func setupFavoritesTableView() {
        view.addSubview(favoritesTableView)
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self 
        favoritesTableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: FavoritesTableViewCell.reuseId)
        favoritesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        favoritesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        favoritesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        favoritesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupProceedToCheckoutButton() {
        view.addSubview(proceedToCheckoutButton)
        updateProceedToCheckoutButton()
        proceedToCheckoutButton.addTarget(self, action: #selector(proceedToCheckoutButtonTapped), for: .touchDown)
        proceedToCheckoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        proceedToCheckoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        proceedToCheckoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        proceedToCheckoutButton.heightAnchor.constraint(equalToConstant: 56).isActive = true 
    }
    
    private func handleDeleteAction(indexPath: IndexPath) {
        FavoritesStorage.shared.favoriteItems.remove(at: indexPath.row)
        favoritesTableView.deleteRows(at: [indexPath], with: .fade)
        updateProceedToCheckoutButton()
        
        NotificationCenter.default.post(name: Notifications.favoritesListChanged, object: nil)
        NotificationCenter.default.post(name: Notifications.addToFavoritesButtonNeedsUpdate, object: nil)
    }
    
    private func updateProceedToCheckoutButton() {
        if FavoritesStorage.shared.favoriteItems.isEmpty {
            proceedToCheckoutButton.isEnabled = false
            proceedToCheckoutButton.alpha = 0.5
        } else {
            proceedToCheckoutButton.isEnabled = true
            proceedToCheckoutButton.alpha = 1
        }
    }
    
    @objc
    private func proceedToCheckoutButtonTapped() {
        let viewController = CheckoutViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    private func updateFavoritesPage() {
        if view.window == nil {
            favoritesTableView.reloadData()
            print("going")
        }
        
        updateProceedToCheckoutButton()
    }
}

// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoritesStorage.shared.favoriteItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.reuseId, for: indexPath) as? FavoritesTableViewCell else { fatalError("Error") }
        
        let productItem = FavoritesStorage.shared.favoriteItems[indexPath.row]
        
        cell.configure(productItem: productItem)
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productItem = FavoritesStorage.shared.favoriteItems[indexPath.row]
        let viewController = ProductInfoViewController(productItem: productItem)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            self?.handleDeleteAction(indexPath: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
