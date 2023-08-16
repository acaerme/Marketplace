//
//  ProductListTableHeaderView.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 18/05/2023.
//

import UIKit

protocol ProductListTableHeaderViewDelegate: AnyObject {
    func headerShowAllButtonTapped(section: Int?)
}

final class ProductListTableHeaderView: UITableViewHeaderFooterView {
    
// MARK: - Properties
    
    static let reuseId = "ProductListTableHeaderView"
    
    weak var delegate: ProductListTableHeaderViewDelegate?
    
    var section: Int?
    
// MARK: - UI Components
    
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
    
// MARK: - Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupTitleLabel()
        setupShowAllButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Private methods
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
    
    private func setupShowAllButton() {
        contentView.addSubview(showAllButton)
        showAllButton.addTarget(self, action: #selector(showAllButtonTapped), for: .touchDown)
        showAllButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        showAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
    }
    
    @objc
    private func showAllButtonTapped() {
        delegate?.headerShowAllButtonTapped(section: section)
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
