//
//  ProductCategoryListViewController.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 18/05/2023.
//

import UIKit

final class ProductCategoryListViewController: UIViewController {
    
// MARK: - Properties
    
    private let products: [Product]
    
// MARK: - UI Elements
    
    private let productsListCollectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 18) / 2, height: UIScreen.main.bounds.height / 3.75)
        collectionViewFlowLayout.minimumInteritemSpacing = 6
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        return collectionView
    }()
    
// MARK: - Init

    init(products: [Product]) {
        self.products = products
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupProductsCollectionView()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateCategoryPage),
            name: Notifications.favoritesListChanged,
            object: nil
        )
    }
    
// MARK: - Private methods
    
    private func setupProductsCollectionView() {
        view.addSubview(productsListCollectionView)
        productsListCollectionView.dataSource = self
        productsListCollectionView.delegate = self
        productsListCollectionView.register(ProductListCollectionViewCell.self, forCellWithReuseIdentifier: ProductListCollectionViewCell.reuseId)
        productsListCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        productsListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        productsListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        productsListCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc
    private func updateCategoryPage() {
        if view.window == nil {
            productsListCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProductCategoryListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCollectionViewCell.reuseId, for: indexPath) as? ProductListCollectionViewCell else { fatalError("Error") }
        let productItem = products[indexPath.item]
        cell.delegate = self
        cell.configure(productItem: productItem)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ProductCategoryListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productItem = products[indexPath.item]
        
        let viewController = ProductInfoViewController(productItem: productItem)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - ProductListCollectionViewCellDelegate

extension ProductCategoryListViewController: ProductListCollectionViewCellDelegate {
    
    func cellLikeButtonTapped(cell: ProductListCollectionViewCell, isSelected: Bool) {
        guard let indexPath = productsListCollectionView.indexPath(for: cell) else { return }
        let productItem = products[indexPath.item]
        
        if isSelected {
            FavoritesStorage.shared.favoriteItems.append(productItem)
        } else {
            FavoritesStorage.shared.favoriteItems.removeAll { $0 === productItem }
        }
        
        NotificationCenter.default.post(name: Notifications.favoritesListChanged, object: nil)
    }
}


