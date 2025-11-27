//
//  LoginViewModel.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 26/11/25.
//
import Combine
import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var messageAlert = ""
    @Published var showAlert = false
    
    var userRequirement: UserRequirementProtocol
    
    init(userRequirement: UserRequirementProtocol = UserRequirement.shared) {
        self.userRequirement = userRequirement
    }
    
    @MainActor
    func setCurrentUser() {
        if self.email != "" {
            self.userRequirement.setCurrentUser(email: self.email)
        } else {
            self.messageAlert = "Correo inválido"
            self.showAlert = true
        }
    }
    
    @MainActor
    func getCurrentUser() {
        self.email = self.userRequirement.getCurrentUser() ?? ""
    }
}
