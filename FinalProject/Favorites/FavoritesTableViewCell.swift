//
//  FavoritesTableViewCell.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 26/05/2023.
//

import UIKit

final class FavoritesTableViewCell: UITableViewCell {
    
// MARK: - Properties
    
    static let reuseId = "FavoritesTableViewCell"
    
// MARK: - UI Components
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupProductImageView()
        setupProductPriceLabel()
        setupProductTitleLavel()
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
    
    private func setupProductImageView() {
        contentView.addSubview(productImageView)
        productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        productImageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        productImageView.widthAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    private func setupProductPriceLabel() {
        contentView.addSubview(productPriceLabel)
        productPriceLabel.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 8).isActive = true
        productPriceLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 32).isActive = true
        productPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32).isActive = true
    }
    
    private func setupProductTitleLavel() {
        contentView.addSubview(productTitleLabel)
        productTitleLabel.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 8).isActive = true
        productTitleLabel.leadingAnchor.constraint(equalTo: productPriceLabel.leadingAnchor).isActive = true
        productTitleLabel.trailingAnchor.constraint(equalTo: productPriceLabel.trailingAnchor).isActive = true
    }
    
    func configure(productItem: Product) {
        productPriceLabel.text = "$" + productItem.price
        productTitleLabel.text = productItem.title
        
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
}
