//
//  ProductListViewController.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 11/05/2023.
//

import UIKit

final class ProductListViewController: UIViewController {
    
// MARK: - Properties
    
    private var storedSections: [Section] = []
    
    private var searchResultSection: Section?
    
    private var isSearching = false
    
    private var sections: [Section] {
        if let searchResultSection = searchResultSection {
            return [searchResultSection]
        }
        
        if isSearching {
            return []
        }
        
        return storedSections
    }

// MARK: - UI Elements

    private let productsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 240
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DatabaseManager.shared.fetchData { [weak self] sections in
            self?.storedSections = sections
            self?.setupProductsTableView()
        }
        
        title = "Home"
        view.backgroundColor = .white
                
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateHomePage),
            name: Notifications.favoritesListChanged,
            object: nil
        )
        
        setupNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if FavoritesStorage.shared.isFetched == false {
            
            DatabaseManager.shared.getAllFavorites { [weak self] in
                print(FavoritesStorage.shared.favoriteItems)
                self?.productsTableView.reloadData()
                NotificationCenter.default.post(name: Notifications.favoritesListChanged, object: nil)
            }
            
            FavoritesStorage.shared.isFetched = true
        }
    }
    
// MARK: - Private methods
    
    private func setupProductsTableView() {
        view.addSubview(productsTableView)
        productsTableView.dataSource = self
        productsTableView.delegate = self
        productsTableView.register(ProductListTableViewCell.self, forCellReuseIdentifier: ProductListTableViewCell.reuseId)
        productsTableView.register(ProductListTableHeaderView.self, forHeaderFooterViewReuseIdentifier: ProductListTableHeaderView.reuseId)
        productsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        productsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        productsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        productsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        productsTableView.backgroundColor = .white
    }
    
    private func setupNavigationItem() {
        navigationItem.searchController = UISearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.searchBar.delegate = self
    }
    
    @objc
    private func updateHomePage() {
        if view.window == nil {
            productsTableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

extension ProductListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.reuseId, for: indexPath) as? ProductListTableViewCell else { fatalError("Error") }
        
        let products = sections[indexPath.section].products
        
        cell.delegate = self
        cell.configure(products: products)
        cell.sectionIndex = indexPath.section

        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProductListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProductListTableHeaderView.reuseId) as? ProductListTableHeaderView else { fatalError("Error") }
        let currentSection = sections[section]
        header.configure(title: currentSection.title)
        header.delegate = self
        header.section = section
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
}

// MARK: - UISearchResultsUpdating

extension ProductListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        let allProducts = storedSections.flatMap { $0.products }
        
        let filteredProducts = allProducts.filter { $0.title.lowercased().contains(text.lowercased()) }
        
        if !filteredProducts.isEmpty {
            searchResultSection = Section(title: "Search result", products: filteredProducts)
        } else {
            searchResultSection = nil
        }
        
        productsTableView.reloadData()
    }
}

// MARK: - ProductListTableHeaderViewDelegate

extension ProductListViewController: ProductListTableHeaderViewDelegate {
    
    func headerShowAllButtonTapped(section: Int?) {
        guard let currentSection = section else { return }
        let section = sections[currentSection]
        let viewController = ProductCategoryListViewController(products: section.products)
        viewController.title = section.title
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension ProductListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResultSection = nil
        
        productsTableView.reloadData()
    }
}

// MARK: - ProductListTableViewCellDelegate

extension ProductListViewController: ProductListTableViewCellDelegate {
    
    func cellTapped(productItem: Product) {
        let viewController = ProductInfoViewController(productItem: productItem)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
