//
//  PokemonListRequirement.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 02/11/25.
//

import Foundation

protocol PokemonListRequirementProtocol {
    func getPokemonList(limit: Int) async -> Pokedex?
}

class PokemonListRequirement: PokemonListRequirementProtocol {
    static let shared: PokemonListRequirementProtocol = PokemonListRequirement()
    let dataRepository: PokemonRepository

    init(dataRepository: PokemonRepository = PokemonRepository.shared) {
        self.dataRepository = dataRepository
    }
    
    func getPokemonList(limit: Int) async -> Pokedex? {
        return await dataRepository.getPokemonList(limit: limit)
    }
}
