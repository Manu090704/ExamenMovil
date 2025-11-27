//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 26/11/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonDetailView: View {
    var pokemonBase: PokemonBase
    
    var body: some View {
        VStack {
            WebImage(url: URL(string: pokemonBase.perfil?.sprites.front_default ?? ""))
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
            Text(pokemonBase.pokemon.name)
        }
    }
}
