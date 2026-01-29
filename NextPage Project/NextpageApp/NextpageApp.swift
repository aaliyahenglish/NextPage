//
//  NextpageAppApp.swift
//  NextpageApp
//
//  Created by Aaliyah English on 11/28/25.
//

import SwiftUI
import Firebase

@main
struct NextpageAppApp: App {
    @State private var authManager: AuthManager
    
    init() {
        FirebaseApp.configure()
        // Initialize AuthManager after Firebase is configured
        _authManager = State(initialValue: AuthManager())
    }
    
    var body: some Scene {
        WindowGroup {
            if authManager.isSignedIn {
                HomeView()
                    .environment(authManager)
            } else {
                LoginView()
                    .environment(authManager)
            }
        }
    }
}
