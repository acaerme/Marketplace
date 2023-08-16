//
//  ProductListCollectionViewCell.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 12/05/2023.
//

import UIKit

protocol ProductListCollectionViewCellDelegate: AnyObject {
    func cellLikeButtonTapped(cell: ProductListCollectionViewCell, isSelected: Bool)
}

final class ProductListCollectionViewCell: UICollectionViewCell {
    
// MARK: - Properties
    
    static let reuseId = "ProductListCollectionViewCell"
    
    weak var delegate: ProductListCollectionViewCellDelegate?
           
// MARK: - UI Components
    
    private var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        button.tintColor = .black 
        return button
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let productTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
// MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupProductImageView()
        setupPriceLabel()
        setupProductTitleLabel()
        setupLikeButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Private methods
    
    private func setupProductImageView() {
        contentView.addSubview(productImageView)
        productImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        productImageView.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    private func setupPriceLabel() {
        contentView.addSubview(productPriceLabel)
        productPriceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 4).isActive = true
        productPriceLabel.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor, constant: 8).isActive = true
        productPriceLabel.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -4).isActive = true
    }
    
    private func setupProductTitleLabel() {
        contentView.addSubview(productTitleLabel)
        productTitleLabel.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 4).isActive = true
        productTitleLabel.leadingAnchor.constraint(equalTo: productPriceLabel.leadingAnchor).isActive = true
        productTitleLabel.trailingAnchor.constraint(equalTo: productPriceLabel.trailingAnchor).isActive = true
    }
    
    private func setupLikeButton() {
        contentView.addSubview(likeButton)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchDown)
        likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
    }
    
    @objc
    private func likeButtonTapped() {
        likeButton.isSelected = !likeButton.isSelected
        
        updateLikeButton(isSelected: likeButton.isSelected)
        
        delegate?.cellLikeButtonTapped(cell: self, isSelected: likeButton.isSelected)
    }
    
    private func updateLikeButton(isSelected: Bool) {
        print(isSelected)
        likeButton.isSelected = isSelected
        
        if isSelected {
            likeButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            likeButton.tintColor = .red
        } else {
            likeButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            likeButton.tintColor = .black
        }
    }
    
    private func loadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else { return }
        
        let request = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            let image = UIImage(data: data)
            
            completion(image)
        }
        
        request.resume()
    }
    
    func configure(productItem: Product) {
        productPriceLabel.text = "$" + productItem.price
        productTitleLabel.text = productItem.title
        updateLikeButton(isSelected: FavoritesStorage.shared.favoriteItems.contains { $0.id == productItem.id})
        loadImage(url: productItem.imageURL) { [weak self] image in
            guard let image = image else { return }
            
            productItem.image = image
            
            DispatchQueue.main.async {
                self?.productImageView.image = image
            }
        }
    }
}
