//
//  FavoritesStorage.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 26/05/2023.
//

final class FavoritesStorage {
    
    static let shared = FavoritesStorage()
    
    var favoriteItems: [Product] = []
    
    var isFetched = false 
    
    private init() {}
}
