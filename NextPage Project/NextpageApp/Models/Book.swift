//
//  Book.swift
//  NextpageApp
//
//  Created by Aaliyah English on 11/30/25.
//

import Foundation

struct Book: Identifiable, Codable {
    let id: String // Google Books volume ID
    let title: String
    let authors: [String]
    let description: String?
    let coverImageURL: String?
    let infoLinks: BookLinks
    
    var authorString: String {
        authors.joined(separator: ", ")
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case authors
        case description
        case coverImageURL
        case infoLinks
    }
}

struct BookLinks: Codable {
    let amazon: String?
    let goodreads: String?
    let preview: String?
    let info: String?
    
    enum CodingKeys: String, CodingKey {
        case amazon
        case goodreads
        case preview
        case info
    }
}

// Google Books API response structures
struct GoogleBooksResponse: Codable {
    let items: [GoogleBooksVolume]?
}

struct GoogleBooksVolume: Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let description: String?
    let imageLinks: ImageLinks?
    let infoLink: String?
    let previewLink: String?
    let canonicalVolumeLink: String?
    
    struct ImageLinks: Codable {
        let thumbnail: String?
        let smallThumbnail: String?
    }
}

// Extension to convert Google Books API response to Book model
extension GoogleBooksVolume {
    func toBook() -> Book {
        let authors = volumeInfo.authors ?? ["Unknown Author"]
        let coverURL = volumeInfo.imageLinks?.thumbnail?.replacingOccurrences(of: "http://", with: "https://")
        
        var links = BookLinks(amazon: nil, goodreads: nil, preview: nil, info: nil)
        
        // Try to extract Amazon link from infoLink (common pattern)
        if let infoLink = volumeInfo.infoLink {
            links = BookLinks(
                amazon: infoLink.contains("amazon") ? infoLink : nil,
                goodreads: infoLink.contains("goodreads") ? infoLink : nil,
                preview: volumeInfo.previewLink,
                info: infoLink
            )
        }
        
        return Book(
            id: id,
            title: volumeInfo.title,
            authors: authors,
            description: volumeInfo.description,
            coverImageURL: coverURL,
            infoLinks: links
        )
    }
}

