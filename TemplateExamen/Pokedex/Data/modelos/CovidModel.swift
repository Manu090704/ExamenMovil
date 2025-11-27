//
//  Pokedex.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 19/10/25.
//

import Foundation

struct CovidData : Decodable, Identifiable{
    let id = UUID()
    let country: String
    let region: String
    let cases: [String: CovidCase]
    
}

struct CovidCase : Decodable{
    let total: Int?
    let new: Int?
}
