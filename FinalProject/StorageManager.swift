//
//  StorageManager.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 27/06/2023.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let reference = Storage.storage().reference()
    
    private init() {}
    
    func uploadAvatarImage(data: Data?, email: String, completion: @escaping (String?) -> Void) {
        guard let data = data else {
            UserDefaults.standard.set("", forKey: "avatarImage")
            return
        }
        
        reference.child("images/\(email)-avatar-picture.png").putData(data) { [weak self] metadata, error in
            guard error == nil else { return }
            
            self?.reference.child("images/\(email)-avatar-picture.png").downloadURL { url, error in
                guard let url = url, error == nil else { return }
                
                let absoluteString = url.absoluteString
                
                completion(absoluteString)
            }
        }
    }
}
