//
//  AuthManager.swift
//  NextpageApp
//
//  Created by Aaliyah English on 11/30/25.
//

import Foundation
import FirebaseAuth


@Observable
class AuthManager {
    var user: User?
    
    let isMocked: Bool
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    var userEmail: String? {
        isMocked ? "aaliyahlovescats@gmail.com" : user?.email
    }
    
    var isSignedIn: Bool {
        user != nil
    }
    
    init(isMocked: Bool = false) {
        self.isMocked = isMocked
        if !isMocked {
            // Listen for auth state changes
            authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
                self?.user = user
            }
        }
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func signUp(email: String, password: String) {
        Task {
            do {
                let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                self.user = authResult.user
            } catch {
                print(error)
            }
        }
    }
    func signIn(email: String, password: String) {
        Task {
            do {
                let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                self.user = authResult.user
            } catch {
                print(error)
            }
        }
    }
    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
        } catch {
            print(error)
        }
    }
}
