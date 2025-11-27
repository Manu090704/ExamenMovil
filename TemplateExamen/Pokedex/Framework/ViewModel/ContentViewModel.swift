//
//  ContentViewModel.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 30/10/25.
//
import Foundation
import Combine

class ContentViewModel: ObservableObject {
    @Published var pokemonList = [PokemonBase]()
    
    var pokemonListRequirement: PokemonListRequirementProtocol
    var pokemonInfoRequirement: PokemonInfoRequirementProtocol

    init(pokemonListRequirement: PokemonListRequirementProtocol = PokemonListRequirement.shared,
            pokemonInfoRequirement: PokemonInfoRequirementProtocol = PokemonInfoRequirement.shared) {
        self.pokemonListRequirement = pokemonListRequirement
        self.pokemonInfoRequirement = pokemonInfoRequirement
    }
    
    @MainActor
    func getPokemonList() async{
        let result = await pokemonListRequirement.getPokemonList(limit: 1279)
        
        for i in 0...result!.results.count-1 {
            let numberPokemon = Int(result!.results[i].url.split(separator: "/")[5])!
            
            let infoPokemon = await pokemonInfoRequirement.getPokemonInfo(numberPokemon: Int(String(numberPokemon))!)
            let tempPokemon = PokemonBase(id: Int(String(numberPokemon))!, pokemon: result!.results[i], perfil: infoPokemon)
            
            self.pokemonList.append(tempPokemon)
        }
    }
}
