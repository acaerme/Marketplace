//
//  ProductSectionHeaderView.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 12/05/2023.
//

import UIKit

final class ProductSectionHeaderView: UICollectionReusableView {
    
    static let reuseId = "ProductSectionHeaderView"
    
    weak var delegate: ProductListViewController?
    
    var indexPath: IndexPath?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let showAllButton: UIButton = {
        let configuration = UIButton.Configuration.gray()
        let button = UIButton()
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show all", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTitleLabel()
        setupShowAllButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    }
    
    private func setupShowAllButton() {
        addSubview(showAllButton)
        showAllButton.addTarget(self, action: #selector(showAllButtonTapped), for: .touchDown)
        showAllButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        showAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
    
    @objc
    private func showAllButtonTapped() {
        delegate?.headerShowAllButtonTapped(indexPath: indexPath)
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
