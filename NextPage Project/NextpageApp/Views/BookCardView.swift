//
//  BookCardView.swift
//  NextpageApp
//
//  Created by Aaliyah English on 11/30/25.
//

import SwiftUI

struct BookCardView: View {
    let book: Book
    @State private var dragOffset = CGSize.zero
    @State private var rotation: Double = 0
    let onSwipeLeft: () -> Void
    let onSwipeRight: () -> Void
    let onTap: () -> Void
    
    private let swipeThreshold: CGFloat = 100
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.pink.opacity(0.8), Color.green.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(radius: 10)
                
                VStack(spacing: 15) {
                    // Book Cover Image
                    AsyncImage(url: URL(string: book.coverImageURL ?? "")) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.3))
                                    .frame(width: 150, height: 220)
                                ProgressView()
                            }
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 220)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        case .failure:
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.3))
                                    .frame(width: 150, height: 220)
                                Image(systemName: "book.closed")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    // Book Title
                    Text(book.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal)
                    
                    // Author
                    Text(book.authorString)
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                    
                    // Description preview
                    if let description = book.description {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(3)
                            .padding(.horizontal)
                    }
                }
                .padding()
            }
            .offset(dragOffset)
            .rotationEffect(.degrees(rotation))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                        rotation = Double(value.translation.width / 10)
                    }
                    .onEnded { value in
                        let horizontalAmount = value.translation.width
                        
                        if abs(horizontalAmount) > swipeThreshold {
                            if horizontalAmount > 0 {
                                // Swipe right - like
                                withAnimation(.spring()) {
                                    dragOffset = CGSize(width: 1000, height: 0)
                                    rotation = 20
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    onSwipeRight()
                                }
                            } else {
                                // Swipe left - skip
                                withAnimation(.spring()) {
                                    dragOffset = CGSize(width: -1000, height: 0)
                                    rotation = -20
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    onSwipeLeft()
                                }
                            }
                        } else {
                            // Return to center
                            withAnimation(.spring()) {
                                dragOffset = .zero
                                rotation = 0
                            }
                        }
                    }
            )
            .onTapGesture {
                onTap()
            }
        }
    }
}

