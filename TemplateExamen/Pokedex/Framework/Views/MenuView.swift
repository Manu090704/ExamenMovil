//
//  MenuView.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 26/11/25.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        TabView {
            ContentView().tabItem {
                Image(systemName: "cricket.ball")
                Text("Pokedex")
            }
            PerfilView().tabItem {
                Image(systemName: "person")
                Text("Perfil")
            }
        }
    }
}
