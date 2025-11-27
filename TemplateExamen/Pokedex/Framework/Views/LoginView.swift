//
//  LoginView.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 17/11/25.
//

import SwiftUI
import FlowStacks

struct LoginView: View {
    @EnvironmentObject var navigator: FlowNavigator<Screen>
    @StateObject var loginViewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: 0) {
            TextField(text: $loginViewModel.email) {
                Text("Correo Electrónico")
            }.multilineTextAlignment(.center)
                .keyboardType(.emailAddress)
                .padding()
                .font(.title3)
                .textInputAutocapitalization(.never)

            Divider()

            Button {
                loginViewModel.setCurrentUser()
                navigator.presentCover(.menu)
            } label: {
                Text("Acceder")
            }
        }.onAppear {
            loginViewModel.getCurrentUser()

            if loginViewModel.email != "" {
                navigator.goBackToRoot()
            }
        }.padding()
            .alert(isPresented: $loginViewModel.showAlert) {
                Alert(
                    title: Text("Oops!"),
                    message: Text(loginViewModel.messageAlert)
                )
            }
    }
}


#Preview {
    LoginView()
}
