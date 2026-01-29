//
//  BookCardsView.swift
//  NextpageApp
//
//  Created by Aaliyah English on 11/30/25.
//

import SwiftUI

struct BookCardsView: View {
    @Environment(AuthManager.self) var authManager
    @State private var books: [Book] = []
    @State private var currentIndex: Int = 0
    @State private var isLoading = true
    @State private var selectedBook: Book?
    @State private var likedBooksService = LikedBooksService()
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.pink.opacity(0.6), Color.green.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if isLoading {
                ProgressView("Loading books...")
                    .tint(.white)
            } else if let error = errorMessage {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                    Text("Error loading books")
                        .font(.title2)
                        .foregroundColor(.white)
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("Try Again") {
                        Task {
                            await loadBooks()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                }
            } else if currentIndex < books.count {
                ZStack {
                    // Show next 2 cards behind for depth effect
                    if currentIndex + 1 < books.count {
                        BookCardView(
                            book: books[currentIndex + 1],
                            onSwipeLeft: {},
                            onSwipeRight: {},
                            onTap: {}
                        )
                        .scaleEffect(0.95)
                        .offset(y: 5)
                        .opacity(0.7)
                        .allowsHitTesting(false) // Don't intercept touches
                        .zIndex(0) // Behind current card
                    }
                    
                    if currentIndex + 2 < books.count {
                        BookCardView(
                            book: books[currentIndex + 2],
                            onSwipeLeft: {},
                            onSwipeRight: {},
                            onTap: {}
                        )
                        .scaleEffect(0.9)
                        .offset(y: 10)
                        .opacity(0.5)
                        .allowsHitTesting(false) // Don't intercept touches
                        .zIndex(-1) // Furthest back
                    }
                    
                    // Current card on top - fully interactive and visible
                    BookCardView(
                        book: books[currentIndex],
                        onSwipeLeft: {
                            handleSwipeLeft()
                        },
                        onSwipeRight: {
                            handleSwipeRight()
                        },
                        onTap: {
                            selectedBook = books[currentIndex]
                        }
                    )
                    .opacity(1.0) // Ensure full opacity
                    .allowsHitTesting(true) // Ensure current card can be tapped
                    .zIndex(1) // On top
                    .id(books[currentIndex].id) // Force recreation when book changes
                }
                .padding()
                
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
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                    Text("You've seen all books!")
                        .font(.title2)
                        .foregroundColor(.white)
                    Text("Check out your 'Currently Seeing' tab to review your matches.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
        .navigationTitle("Discover Books")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    Task {
                        await loadBooks()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.white)
                }
            }
        }
        .task {
            await loadBooks()
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
    
    private func loadBooks() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedBooks = try await GoogleBooksService.shared.fetchBooks(query: "subject:fiction", maxResults: 40)
            await MainActor.run {
                books = fetchedBooks
                currentIndex = 0
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    private func handleSwipeRight() {
        // Like the book - save it
        if let userId = authManager.user?.uid {
            Task {
                await likedBooksService.addLikedBook(books[currentIndex], userId: userId)
            }
        }
        
        // Move to next card
        withAnimation {
            currentIndex += 1
        }
    }
    
    private func handleSwipeLeft() {
        // Skip the book - just move to next
        withAnimation {
            currentIndex += 1
        }
    }
}

