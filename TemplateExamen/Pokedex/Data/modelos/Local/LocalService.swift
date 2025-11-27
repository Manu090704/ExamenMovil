//
//  LocalService.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 17/11/25.
//

import Foundation

class LocalService{
    static let shared = LocalService()

    init(){}
    
    func getCurrentUser() -> String? {
        return UserDefaults.standard.string(forKey: "currentUser")
    }

    func setCurrentUser(email: String) {
        UserDefaults.standard.set(email, forKey: "currentUser")
    }

    func removeCurrentUser() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
    
}
