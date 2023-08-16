//
//  ProductListTableViewCell.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 18/05/2023.
//

import UIKit

protocol ProductListTableViewCellDelegate: AnyObject {
    func cellTapped(productItem: Product)
}

final class ProductListTableViewCell: UITableViewCell {
    
// MARK: - Properties
    
    static let reuseId = "ProductListTableViewCell"
    
    weak var delegate: ProductListTableViewCellDelegate?
    
    private var products: [Product] = []
    
    var sectionIndex: Int?
    
// MARK: - UI Components
    
    private let productsListCollectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 18) / 3, height: 240)
        collectionViewFlowLayout.minimumInteritemSpacing = 6
        collectionViewFlowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
// MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupProductsListCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Private methods
    
    private func setupProductsListCollectionView() {
        contentView.addSubview(productsListCollectionView)
        productsListCollectionView.dataSource = self
        productsListCollectionView.delegate = self
        productsListCollectionView.register(ProductListCollectionViewCell.self, forCellWithReuseIdentifier: ProductListCollectionViewCell.reuseId)
        productsListCollectionView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        productsListCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        productsListCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        productsListCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func configure(products: [Product]) {
        self.products = products
        
        productsListCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension ProductListTableViewCell: UICollectionViewDataSource {
    
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

extension ProductListTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productItem = products[indexPath.item]
        
        delegate?.cellTapped(productItem: productItem)
    }
}

// MARK: - ProductListCollectionViewCellDelegate

extension ProductListTableViewCell: ProductListCollectionViewCellDelegate {
    
    func cellLikeButtonTapped(cell: ProductListCollectionViewCell, isSelected: Bool) {
        guard let indexPath = productsListCollectionView.indexPath(for: cell) else { return }
        let productItem = products[indexPath.item]
        print(isSelected)
        if isSelected {
            FavoritesStorage.shared.favoriteItems.append(productItem)
            DatabaseManager.shared.uploadFavoriteItem(productItem: productItem)
        } else {
            FavoritesStorage.shared.favoriteItems.removeAll { $0.id == productItem.id}
            DatabaseManager.shared.deleteFavoriteItem(productItem: productItem)
        }
        
        NotificationCenter.default.post(name: Notifications.favoritesListChanged, object: nil)
    }
}
