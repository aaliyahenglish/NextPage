//
//  LoginView.swift
//  NextpageApp
//
//  Created by Aaliyah English on 11/28/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthManager.self) var authManager
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack {
            // Pink to Green gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color.pink.opacity(0.6), Color.green.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Welcome to Next Page!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
                
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .background(Color.white.opacity(0.9))
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .background(Color.white.opacity(0.9))
                }
                .textInputAutocapitalization(.never)
                .padding(40)
                
                HStack(spacing: 20) {
                    Button("Sign Up") {
                        print("Sign up user: \(email), \(password)")
                        authManager.signUp(email: email, password: password)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.pink)
                    
                    Button("Login") {
                        print("Login user: \(email), \(password)")
                        authManager.signIn(email: email, password: password)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
            }
            
            // Name overlay at the top
            VStack {
                HStack {
                    Spacer()
                    Text("Aaliyah English Z23670086")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.black.opacity(0.4))
                        )
                        .padding(.top, 10)
                        .padding(.trailing, 10)
                }
                Spacer()
            }
        }
    }
}
