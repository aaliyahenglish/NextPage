//
//  CurrentlySeeingView.swift
//  NextpageApp
//
//  Created by Aaliyah English on 11/30/25.
//

import SwiftUI

struct CurrentlySeeingView: View {
    @Environment(AuthManager.self) var authManager
    @State private var likedBooksService = LikedBooksService()
    @State private var selectedBook: Book?
    @State private var showingDetail = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.pink.opacity(0.3), Color.green.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if likedBooksService.likedBooks.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.pink.opacity(0.6))
                        Text("No Books Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        Text("Swipe right on books you like to see them here!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 15),
                            GridItem(.flexible(), spacing: 15)
                        ], spacing: 20) {
                            ForEach(likedBooksService.likedBooks) { book in
                                BookGridItem(book: book) {
                                    selectedBook = book
                                    showingDetail = true
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Currently Seeing")
            .navigationBarTitleDisplayMode(.large)
            .task {
                if let userId = authManager.user?.uid {
                    await likedBooksService.loadLikedBooks(userId: userId)
                }
            }
            .sheet(item: $selectedBook) { book in
                NavigationView {
                    BookDetailView(book: book)
                }
            }
        }
    }
}

struct BookGridItem: View {
    let book: Book
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: book.coverImageURL ?? "")) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(2/3, contentMode: .fit)
                        ProgressView()
                    }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                case .failure:
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(2/3, contentMode: .fit)
                        Image(systemName: "book.closed")
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                    }
                @unknown default:
                    EmptyView()
                }
            }
            
            Text(book.title)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(2)
                .foregroundColor(.primary)
            
            Text(book.authorString)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .onTapGesture {
            onTap()
        }
    }
}

