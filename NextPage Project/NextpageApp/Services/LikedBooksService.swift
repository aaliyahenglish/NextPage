//
//  LikedBooksService.swift
//  NextpageApp
//
//  Created by Aaliyah English on 11/30/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@Observable
class LikedBooksService {
    var likedBooks: [Book] = []
    private let db = Firestore.firestore()
    
    func addLikedBook(_ book: Book, userId: String) async {
        do {
            let bookData: [String: Any] = [
                "id": book.id,
                "title": book.title,
                "authors": book.authors,
                "description": book.description ?? "",
                "coverImageURL": book.coverImageURL ?? "",
                "infoLinks": [
                    "amazon": book.infoLinks.amazon ?? "",
                    "goodreads": book.infoLinks.goodreads ?? "",
                    "preview": book.infoLinks.preview ?? "",
                    "info": book.infoLinks.info ?? ""
                ],
                "timestamp": Timestamp()
            ]
            
            try await db.collection("users").document(userId).collection("likedBooks").document(book.id).setData(bookData)
            await loadLikedBooks(userId: userId)
        } catch {
            print("Error adding liked book: \(error)")
        }
    }
    
    func removeLikedBook(_ bookId: String, userId: String) async {
        do {
            try await db.collection("users").document(userId).collection("likedBooks").document(bookId).delete()
            await loadLikedBooks(userId: userId)
        } catch {
            print("Error removing liked book: \(error)")
        }
    }
    
    func loadLikedBooks(userId: String) async {
        do {
            let snapshot = try await db.collection("users").document(userId).collection("likedBooks").getDocuments()
            
            likedBooks = snapshot.documents.compactMap { doc -> Book? in
                let data = doc.data()
                guard let id = data["id"] as? String,
                      let title = data["title"] as? String,
                      let authors = data["authors"] as? [String] else {
                    return nil
                }
                
                let description = data["description"] as? String
                let coverImageURL = data["coverImageURL"] as? String
                
                let linksData = data["infoLinks"] as? [String: Any] ?? [:]
                
                // Helper to convert empty strings to nil
                func nonEmptyString(_ value: Any?) -> String? {
                    guard let str = value as? String, !str.isEmpty else { return nil }
                    return str
                }
                
                let links = BookLinks(
                    amazon: nonEmptyString(linksData["amazon"]),
                    goodreads: nonEmptyString(linksData["goodreads"]),
                    preview: nonEmptyString(linksData["preview"]),
                    info: nonEmptyString(linksData["info"])
                )
                
                return Book(
                    id: id,
                    title: title,
                    authors: authors,
                    description: description,
                    coverImageURL: coverImageURL,
                    infoLinks: links
                )
            }
        } catch {
            print("Error loading liked books: \(error)")
        }
    }
    
    func isBookLiked(_ bookId: String) -> Bool {
        likedBooks.contains { $0.id == bookId }
    }
}

