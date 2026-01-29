//
//  GoogleBooksService.swift
//  NextpageApp
//
//  Created by Aaliyah English on 11/30/25.
//

import Foundation

class GoogleBooksService {
    static let shared = GoogleBooksService()
    
    private let baseURL = "https://www.googleapis.com/books/v1/volumes"
    
    private init() {}
    
    func fetchBooks(query: String = "subject:romance", maxResults: Int = 20) async throws -> [Book] {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NSError(domain: "GoogleBooksService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid query string"])
        }
        
        let urlString = "\(baseURL)?q=\(encodedQuery)&maxResults=\(maxResults)&orderBy=newest"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "GoogleBooksService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)
        
        guard let items = response.items else {
            return []
        }
        
        return items.compactMap { $0.toBook() }
    }
    
    func fetchBook(byId id: String) async throws -> Book? {
        let urlString = "\(baseURL)/\(id)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "GoogleBooksService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let volume = try JSONDecoder().decode(GoogleBooksVolume.self, from: data)
        
        return volume.toBook()
    }
}

