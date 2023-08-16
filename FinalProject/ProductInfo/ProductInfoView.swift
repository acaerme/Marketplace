//
//  ProductInfoView.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 08/06/2023.
//

import UIKit

final class ProductInfoView: UIView {
    
// MARK: - Properties
    
    private let productItem: Product
    
    private let dataSource: UITableViewDataSource
    
// MARK: - UI Elements
    
    private let addToFavoritesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let productInfoScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()

    private let productTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 19)
        return label
    }()
    
    private let productCharacteristicsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 30
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
// MARK: - Init
    
    init(productItem: Product, dataSource: UITableViewDataSource) {
        self.productItem = productItem
        self.dataSource = dataSource
        
        super.init(frame: .zero)
        
        setupAddToFavoritesButton()
        setupProductInfoScrollView()
        setupContentView()
        setupProductImageView()
        setupProductPriceLabel()
        setupProductTitleLabel()
        setupProductCharacteristicsTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Private methods
    
    private func loadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else { return }
        
        let request = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            let image = UIImage(data: data)
            
            completion(image)
        }
        
        request.resume()
    }
    
    private func setupAddToFavoritesButton() {
        addSubview(addToFavoritesButton)
        updateButton(isLiked: FavoritesStorage.shared.favoriteItems.contains { $0 === productItem})
        addToFavoritesButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        addToFavoritesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        addToFavoritesButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        addToFavoritesButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    private func setupProductInfoScrollView() {
        addSubview(productInfoScrollView)
        productInfoScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        productInfoScrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        productInfoScrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        productInfoScrollView.bottomAnchor.constraint(equalTo: addToFavoritesButton.topAnchor, constant: -4).isActive = true
    }

    private func setupContentView() {
        productInfoScrollView.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: productInfoScrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: productInfoScrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: productInfoScrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: productInfoScrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: productInfoScrollView.widthAnchor).isActive = true
    }

    private func setupProductImageView() {
        contentView.addSubview(productImageView)
        productImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6).isActive = true
        productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6).isActive = true
        productImageView.heightAnchor.constraint(equalToConstant: 280).isActive = true
        
        if productItem.image == nil {
            loadImage(url: productItem.imageURL) { [weak self] image in
                guard let image = image else { return }
                
                DispatchQueue.main.async {
                    self?.productImageView.image = image
                }
            }
        } else {
            productImageView.image = productItem.image
        }
    }
    
    private func setupProductPriceLabel() {
        contentView.addSubview(productPriceLabel)
        productPriceLabel.text = "$" + productItem.price
        productPriceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8).isActive = true
        productPriceLabel.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor, constant: 16).isActive = true
        productPriceLabel.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -16).isActive = true
    }

    private func setupProductTitleLabel() {
        contentView.addSubview(productTitleLabel)
        productTitleLabel.text = productItem.title
        productTitleLabel.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 8).isActive = true
        productTitleLabel.leadingAnchor.constraint(equalTo: productPriceLabel.leadingAnchor).isActive = true
        productTitleLabel.trailingAnchor.constraint(equalTo: productPriceLabel.trailingAnchor).isActive = true
    }
    
    private func setupProductCharacteristicsTableView() {
        contentView.addSubview(productCharacteristicsTableView)
        productCharacteristicsTableView.dataSource = dataSource
        productCharacteristicsTableView.register(ProductInfoTableViewCell.self, forCellReuseIdentifier: ProductInfoTableViewCell.reuseId)
        productCharacteristicsTableView.topAnchor.constraint(equalTo: productTitleLabel.bottomAnchor, constant: 32).isActive = true
        productCharacteristicsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        productCharacteristicsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        productCharacteristicsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        productCharacteristicsTableView.heightAnchor.constraint(equalToConstant: CGFloat((productItem.characteristics?.count ?? 0) * 30)).isActive = true
    }
    
    func addAddToFavoritesButtonTarget(target: Any?, action: Selector) {
        addToFavoritesButton.addTarget(target, action: action, for: .touchDown)
    }
    
    func updateButton(isLiked: Bool) {
        if isLiked {
            addToFavoritesButton.backgroundColor = .systemRed
            addToFavoritesButton.setTitle("Delete from favorites", for: .normal)
        } else {
            addToFavoritesButton.backgroundColor = .systemBlue
            addToFavoritesButton.setTitle("Add to favorites", for: .normal)
        }
    }
}
