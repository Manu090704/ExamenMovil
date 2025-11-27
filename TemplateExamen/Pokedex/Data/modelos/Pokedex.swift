//
//  Pokedex.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 19/10/25.
//

import Foundation

struct Pokedex: Codable {
    var count: Int
    var results: [Pokemon]
}

struct Pokemon: Codable {
    var name: String
    var url: String
}

struct Perfil: Codable {
    var sprites: Sprite
}

struct Sprite: Codable {
    var front_default: String
    var back_default: String
    
    enum CodingKeys: String, CodingKey {
        case front_default = "front_default"
        case back_default = "back_default"
    }
}

struct PokemonBase: Identifiable, Codable {
    var id: Int
    
    var pokemon: Pokemon
    var perfil: Perfil?
}
