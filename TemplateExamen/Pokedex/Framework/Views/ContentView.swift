//
//  ContentView.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 19/10/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @StateObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            List(contentViewModel.pokemonList) { pokemonBase in
                NavigationLink {
                    PokemonDetailView(pokemonBase: pokemonBase)
                } label: {
                    HStack {
                        WebImage(url: URL(string: pokemonBase.perfil?.sprites.front_default ?? ""))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48, alignment: .center)
                        Text(pokemonBase.pokemon.name)
                    }
                }
            }
        }.onAppear {
            Task {
                await contentViewModel.getPokemonList()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
