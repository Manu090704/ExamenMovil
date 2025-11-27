//
//  PerfilView.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 26/11/25.
//

import SwiftUI
import FlowStacks

struct PerfilView: View {
    @StateObject var perfilViewModel = PerfilViewModel()
    /// Agrega la variable de ambiente de la navegación
    @EnvironmentObject var navigator: FlowNavigator<Screen>

    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Text(perfilViewModel.email)
            
            Button {
                perfilViewModel.logOut()
                /// Used by the coordinator to manage the flow
                navigator.goBackToRoot()
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "power")
                    Text("Logout")
                }.foregroundColor(.red)
            }
        }.onAppear {
            perfilViewModel.getCurrentUser()
        }
    }
}
