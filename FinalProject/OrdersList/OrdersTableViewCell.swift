//
//  OrdersTableViewCell.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 20/07/2023.
//

import UIKit

final class OrdersTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseId = "OrdersTableViewCell"
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let itemCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false 
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupPriceLabel()
        setupItemCountLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupPriceLabel() {
        contentView.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32).isActive = true
    }
    
    private func setupItemCountLabel() {
        contentView.addSubview(itemCountLabel)
        itemCountLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16).isActive = true
        itemCountLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor).isActive = true
        itemCountLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor).isActive = true
    }
    
    func configure(price: String, itemCount: Int) {
        priceLabel.text = price + "$"
        itemCountLabel.text = "The number of items: \(itemCount)"
    }
}
