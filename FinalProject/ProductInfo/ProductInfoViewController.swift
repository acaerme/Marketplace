//
//  ProductInfoViewController.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 23/05/2023.
//

import UIKit

final class ProductInfoViewController: UIViewController {
    
// MARK: - Properties
    
    lazy private var mainView = ProductInfoView(productItem: productItem, dataSource: self)
    
    private let productItem: Product

    // MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "About product"
        view.backgroundColor = .white
        
        mainView.addAddToFavoritesButtonTarget(target: self, action: #selector(addToFavoritesButtonTapped))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateAddToFavoritesButton),
            name: Notifications.addToFavoritesButtonNeedsUpdate,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: Notifications.addToFavoritesButtonNeedsUpdate, object: nil)
    }

    // MARK: - Init
    
    init(productItem: Product) {
        self.productItem = productItem
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    @objc
    private func addToFavoritesButtonTapped() {
        if !FavoritesStorage.shared.favoriteItems.contains(where: { $0.id == productItem.id}) {
            FavoritesStorage.shared.favoriteItems.append(productItem)
            DatabaseManager.shared.uploadFavoriteItem(productItem: productItem)
        } else {
            FavoritesStorage.shared.favoriteItems.removeAll { $0.id == productItem.id}
            DatabaseManager.shared.deleteFavoriteItem(productItem: productItem)
        }
        
        NotificationCenter.default.post(name: Notifications.favoritesListChanged, object: nil)
        NotificationCenter.default.post(name: Notifications.addToFavoritesButtonNeedsUpdate, object: nil)
    }
    
    @objc
    private func updateAddToFavoritesButton() {
        mainView.updateButton(isLiked: FavoritesStorage.shared.favoriteItems.contains { $0.id == productItem.id})
    }
}

// MARK: - UITableViewDataSource

extension ProductInfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productItem.characteristics?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductInfoTableViewCell.reuseId, for: indexPath) as? ProductInfoTableViewCell else { fatalError("Error") }
        guard let characteristic = productItem.characteristics?[indexPath.row] else { fatalError("Error") }
        
        cell.configure(characteristic: characteristic)
        cell.selectionStyle = .none
        
        return cell
    }
}

