//
//  CoordinatorView.swift
//  Pokedex
//
//  Created by Manuel Bajos Rivera on 26/11/25.
//

import SwiftUI
import FlowStacks

enum Screen {
    case menu
}



struct CoordinatorView: View {
    @State var routes: [Route<Screen>] = []
    
    var body: some View {
        FlowStack($routes, withNavigation: true) {
            // Set home screen destination flows
            ContentView()
                .flowDestination(for: Screen.self) { screen in
                    /// For each screen setup the corresponding view
                    switch screen {
                        case .menu:
                            /// Set view you wnat to go next
                            MenuView()
                    }
                }
        }
    }
}

#Preview {
    CoordinatorView()
}
