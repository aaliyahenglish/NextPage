//
//  HomeView.swift
//  NextpageApp
//
//  Created by Aaliyah English on 11/30/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(AuthManager.self) var authManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            BookCardsView()
                .tabItem {
                    Label("Discover", systemImage: "book")
                }
                .tag(0)
            
            CurrentlySeeingView()
                .tabItem {
                    Label("Currently Seeing", systemImage: "heart.fill")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
                .tag(2)
        }
        .environment(authManager)
    }
}

struct ProfileView: View {
    @Environment(AuthManager.self) var authManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.pink)
                
                Text("Profile")
                    .font(.largeTitle)
                    .bold()
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Email:")
                            .fontWeight(.semibold)
                        Text(authManager.userEmail ?? "Unknown")
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button("Sign Out") {
                    authManager.signOut()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .padding(.bottom, 50)
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}

