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
    
    // --- País ---
    func saveLastCountry(_ country: String) {
        UserDefaults.standard.set(country, forKey: "lastCountry")
    }

    func getLastCountry() -> String? {
        UserDefaults.standard.string(forKey: "lastCountry")
    }

    // --- Fecha ---
    func saveLastDate(_ date: String) {
        UserDefaults.standard.set(date, forKey: "lastDate")
    }

    func getLastDate() -> String? {
        UserDefaults.standard.string(forKey: "lastDate")
    }
}
