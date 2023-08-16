//
//  CheckoutViewController.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 06/06/2023.
//

import UIKit

final class CheckoutViewController: UIViewController {
    
// MARK: - Properties
    
    private lazy var mainView = CheckoutView(dataSource: self, delegate: self)
    
    private var total = 0

// MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Checkout"
        view.backgroundColor = .white
        
        calculateTotal()
    }
    
    // MARK: - Private methods
    
    private func calculateTotal() {
        var total = 0
        
        for i in FavoritesStorage.shared.favoriteItems {
            total += Int(i.price) ?? 0
        }
        
        mainView.total = String(total)
        self.total = total
    }
    
}

extension CheckoutViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoritesStorage.shared.favoriteItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckoutTableViewCell.reuseId, for: indexPath) as? CheckoutTableViewCell else { fatalError("Error") }
        let productItem = FavoritesStorage.shared.favoriteItems[indexPath.row]
        
        cell.configure(productItem: productItem)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension CheckoutViewController: CheckoutViewDelegate {
    
    func shouldEnableButton(nameText: String?, numberText: String?) {
        guard let nameText = nameText, let numberText = numberText else {
            mainView.updateCheckoutButton(enable: false)
            return
        }
        
        let condition = !nameText.isEmpty && numberText.count >= 7
        
        mainView.updateCheckoutButton(enable: condition)
    }
    
    func checkoutButtonTapped() {
        guard let name = mainView.getUserName(), let number = mainView.getUserNumbaer(), let email = UserDefaults.standard.string(forKey: "email") else { return }
                
        let order = Order(price: String(total), products: FavoritesStorage.shared.favoriteItems)
                
        let date = Date().description.replacing("@", with: "-").replacing(".", with: "-")
        
        DatabaseManager.shared.uploadOrder(
            name: name ,
            number: number,
            email: email,
            date: date,
            order: order
        )
        
        OrderStorage.shared.orderItems.append(order)
                        
        let alert = UIAlertController(title: "Checkout", message: "Thank you! Your order has been placed", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            FavoritesStorage.shared.favoriteItems = []
            
            NotificationCenter.default.post(name: Notifications.favoritesListChanged, object: nil)
            NotificationCenter.default.post(name: Notifications.addToFavoritesButtonNeedsUpdate, object: nil)
            
            self?.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
