//
//  PokemonInfoRequirement.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 02/11/25.
//

import Foundation

protocol PokemonInfoRequirementProtocol {
    func getPokemonInfo(numberPokemon:Int) async -> Perfil?
}

class PokemonInfoRequirement: PokemonInfoRequirementProtocol {
    static let shared: PokemonInfoRequirement = PokemonInfoRequirement()
    let dataRepository : PokemonRepository

    init(dataRepository: PokemonRepository = PokemonRepository.shared) {
        self.dataRepository = dataRepository
    }
    
    func getPokemonInfo(numberPokemon: Int) async -> Perfil? {
        return await dataRepository.getPokemonInfo(numberPokemon: numberPokemon)
    }
}

