//
//  DatabaseManager.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 03/07/2023.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    // MARK: - Properties
    
    static let shared = DatabaseManager()
    
    private let reference = Database.database().reference()

    private var products: [Product] = []
    
    private var sectionModels: [SectionModel] = []
    
    // MARK: - Init
    
    private init() {}

    // MARK: - Methods
    
    func uploadOrder(name: String, number: String, email: String, date: String, order: Order) {
        
        var products: [[String: Any]] = []
        
        for item in order.products {
            let product: [String: Any] = [
                "id": item.id,
                "title": item.title,
                "price": item.price,
                "imageURL": item.imageURL
            ]
            
            products.append(product)
        }
        
        let order: [String: Any] = [
            "name": name,
            "number": number,
            "price": order.price,
            "products": products
        ]
        
        let safeEmail = email.replacing("@", with: "-").replacing(".", with: "-")
        
        reference.child("orders/\(safeEmail)/\(date)").setValue(order)
    }
    
    func getAllOrders(for email: String?, completion: @escaping ([NSDictionary]) -> Void) {
        guard let email = email else { return }
        
        let safeEmail = email.replacing(".", with: "-").replacing("@", with: "-")
        
        reference.child("orders/\(safeEmail)").getData { error, snapshot in
            guard let orders = snapshot?.value as? NSDictionary,  error == nil else { return }
            
            var myOrders: [NSDictionary] = []
            
            for order in orders {
                if let order = order.value as? NSDictionary {
                    myOrders.append(order)
                }
            }

            completion(myOrders)
        }
    }
    
    func fetchData(completion: @escaping ([Section]) -> Void) {
        let group = DispatchGroup()
        
        group.enter()
        getAllSections() {
            group.leave()
        }
        
        group.enter()
        getAllProducts {
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.provideSections(completion: completion)
        }
    }
    
    private func getAllSections(completion: @escaping () -> Void) {
        reference.child("sections/").getData { [weak self] error, snapshot in
            guard let data = snapshot?.value as? NSArray, error == nil else { return }
            
            var sectionModels: [SectionModel] = []
            
            for item in data {
                guard let section = item as? NSDictionary,
                      let convertedSection = self?.convert(section: section) else { continue }
                
                sectionModels.append(convertedSection)
            }
            
            self?.sectionModels = sectionModels
            
            completion()
        }
    }
    
    private func getAllProducts(completion: @escaping () -> Void) {
        reference.child("products/").getData { [weak self] error, snapshot in
            guard let data = snapshot?.value as? NSArray, error == nil else { return }
            
            var products: [Product] = []
            
            for item in data {
                guard let product = item as? NSDictionary,
                      let convertedProduct = self?.convert(product: product) else { continue }
                
                products.append(convertedProduct)
            }
            
            self?.products = products
            
            completion()
        }
    }
    
    private func provideSections(completion: ([Section]) -> Void) {
        var sections: [Section] = []
        print(sectionModels.count)
        print(products.count)
        print("AGAGAGAGAGAGAG")
        for sectionModel in sectionModels {
            let products = products.filter { sectionModel.items.contains($0.id) }
            
            if !products.isEmpty {
                sections.append(Section(title: sectionModel.title, products: products))
            }
        }
        
        completion(sections)
    }
    
    func uploadFavoriteItem(productItem: Product) {
        guard let email = UserDefaults.standard.string(forKey: "email") else { return }
        
        let safeEmail = email.replacing(".", with: "-").replacing("@", with: "-")
        
        let product: [String: Any] = [
            "id": productItem.id,
            "title": productItem.title,
            "price": productItem.price,
            "imageURL": productItem.imageURL
        ]
        
        reference.child("favorites/\(safeEmail)/\(productItem.title)").setValue(product)
    }
    
    func deleteFavoriteItem(productItem: Product) {
        guard let email = UserDefaults.standard.string(forKey: "email") else { return }
        
        let safeEmail = email.replacing(".", with: "-").replacing("@", with: "-")
        
        reference.child("favorites/\(safeEmail)/\(productItem.title)").removeValue()
    }
    
    func getAllFavorites(completion: @escaping () -> ()) {
        guard let email = UserDefaults.standard.string(forKey: "email") else { return }
        
        let safeEmail = email.replacing(".", with: "-").replacing("@", with: "-")
        
        reference.child("favorites/\(safeEmail)").getData { error, snapshot in
            guard let data = snapshot?.value as? NSDictionary, error == nil else { return }
            
            for item in data {
                
                guard let item = item.value as? NSDictionary,
                      let id = item["id"] as? Int,
                      let title = item["title"] as? String,
                      let price = item["price"] as? String,
                      let imageURL = item["imageURL"] as? String else { return }
                
                let product = Product(id: id, title: title, price: price, imageURL: imageURL)
                
                FavoritesStorage.shared.favoriteItems.append(product)
            }
            print("zakonchil")
            print(FavoritesStorage.shared.favoriteItems)
            completion()
        }
    }
}
    
    // MARK: - Converters

extension DatabaseManager {
    
    private func convert(section: NSDictionary) -> SectionModel? {
        guard let title = section["title"] as? String,
              let items = section["items"] as? Array<Int> else { return nil }
        
        return SectionModel(title: title, items: items)
    }
    
    private func convert(product: NSDictionary) -> Product? {

        guard let id = product["id"] as? Int,
              let title = product["title"] as? String,
              let price = product["price"] as? String,
              let imageURL = product["imageURL"] as? String else { return nil }
        
        return Product(id: id, title: title, price: price, imageURL: imageURL)
    }
}
