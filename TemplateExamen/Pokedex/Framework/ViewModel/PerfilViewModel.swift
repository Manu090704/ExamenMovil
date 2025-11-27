//
//  PerfilViewModel.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 26/11/25.
//

import Foundation
import Combine

class PerfilViewModel: ObservableObject {
    @Published var email = ""
    
    var userRequirement: UserRequirementProtocol
    
    init(userRequirement: UserRequirementProtocol = UserRequirement.shared) {
        self.userRequirement = userRequirement
    }
    
    @MainActor
    func getCurrentUser() {
        self.email = self.userRequirement.getCurrentUser() ?? ""
    }
    
    @MainActor
        func logOut() {
            self.email = ""
            self.userRequirement.removeCurrentUser()
        }
}
