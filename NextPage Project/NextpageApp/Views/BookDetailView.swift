//
//  BookDetailView.swift
//  NextpageApp
//
//  Created by Aaliyah English on 11/30/25.
//

import SwiftUI

struct BookDetailView: View {
    let book: Book
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Book Cover
                AsyncImage(url: URL(string: book.coverImageURL ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 200, height: 300)
                            ProgressView()
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 300)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    case .failure:
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 200, height: 300)
                            Image(systemName: "book.closed")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                        }
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(.top)
                
                // Title
                Text(book.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Author
                Text("by \(book.authorString)")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Divider()
                    .padding(.horizontal)
                
                // Synopsis
                VStack(alignment: .leading, spacing: 10) {
                    Text("Synopsis")
                        .font(.headline)
                        .foregroundColor(.pink)
                    
                    if let description = book.description {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.primary)
                    } else {
                        Text("No description available.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                // Links
                VStack(alignment: .leading, spacing: 15) {
                    Text("Links")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    if let infoLink = book.infoLinks.info {
                        Link("View on Google Books", destination: URL(string: infoLink)!)
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)
                    }
                    
                    if let previewLink = book.infoLinks.preview {
                        Link("Preview Book", destination: URL(string: previewLink)!)
                            .buttonStyle(.borderedProminent)
                            .tint(.purple)
                    }
                    
                    if let amazonLink = book.infoLinks.amazon {
                        Link("View on Amazon", destination: URL(string: amazonLink)!)
                            .buttonStyle(.borderedProminent)
                            .tint(.orange)
                    }
                    
                    if let goodreadsLink = book.infoLinks.goodreads {
                        Link("View on Goodreads", destination: URL(string: goodreadsLink)!)
                            .buttonStyle(.borderedProminent)
                            .tint(.green)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

