//
//  CheckoutTableViewCell.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 10/06/2023.
//

import UIKit

final class CheckoutTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseId = "CheckoutTableViewCell"
    
    // MARK: - UI Elements
    
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
        setupProductTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
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
    
    private func setupProductTitleLabel() {
        contentView.addSubview(productTitleLabel)
        productTitleLabel.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 8).isActive = true
        productTitleLabel.leadingAnchor.constraint(equalTo: productPriceLabel.leadingAnchor).isActive = true
        productTitleLabel.trailingAnchor.constraint(equalTo: productPriceLabel.trailingAnchor).isActive = true
    }
    
    func configure(productItem: Product) {
        productImageView.image = UIImage(named: productItem.imageURL)
        productPriceLabel.text = "$" + productItem.price
        productTitleLabel.text = productItem.title
        productImageView.image = productItem.image
    }
}
