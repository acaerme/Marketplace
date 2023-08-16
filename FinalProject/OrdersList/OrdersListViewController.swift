//
//  OrdersListViewController.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 20/07/2023.
//

import UIKit

final class OrdersListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let ordersTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80
        return tableView
    }()
    
    private var orders: [Order] = []
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let email = UserDefaults.standard.string(forKey: "email")
        
        DatabaseManager.shared.getAllOrders(for: email) { [weak self] orders in
            guard !orders.isEmpty else { return }
            
            for order in orders {
                guard let price = order["price"] as? String,
                      let products = order["products"] as? [NSDictionary] else { continue }
                
                var orderProducts: [Product] = []
                
                for product in products {
                    guard let id = product["id"] as? Int,
                          let title = product["title"] as? String,
                          let price = product["price"] as? String,
                          let imageURL = product["imageURL"] as? String else { continue }
                    
                    orderProducts.append(Product(id: id, title: title, price: price, imageURL: imageURL))
                }
                
                self?.orders.append(Order(price: price, products: orderProducts))
            }
            
            self?.ordersTableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My orders"
        
        view.backgroundColor = .white
        
        setupOrdersTableView()
    }
    
    // MARK: - Private methods
    
    private func setupOrdersTableView() {
        view.addSubview(ordersTableView)
        ordersTableView.dataSource = self
        ordersTableView.register(OrdersTableViewCell.self, forCellReuseIdentifier: OrdersTableViewCell.reuseId)
        ordersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        ordersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        ordersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        ordersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension OrdersListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrdersTableViewCell.reuseId, for: indexPath) as? OrdersTableViewCell else { fatalError("Error") }
        
        let order = orders[indexPath.row]
        
        cell.configure(price: order.price, itemCount: order.products.count)
        cell.selectionStyle = .none
        
        return cell
    }
}
