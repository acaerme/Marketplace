//
//  OrderStorage.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 20/06/2023.
//

final class OrderStorage {
    
    static let shared = OrderStorage()
    
    var orderItems: [Order] = []
    
    private init() {}
}
