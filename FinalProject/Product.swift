//
//  Product.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 12/05/2023.
//

import UIKit

final class Product {
    
    let id: Int
    let title: String
    let price: String
    let imageURL: String
    let characteristics: [Characteristic]?
    
    var image: UIImage?
    
    init(id: Int, title: String, price: String, imageURL: String, characteristics: [Characteristic]? = nil) {
        self.id = id
        self.title = title
        self.price = price
        self.imageURL = imageURL
        self.characteristics = characteristics
    }
}
