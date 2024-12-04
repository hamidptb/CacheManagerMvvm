//
//  BookModel.swift
//  Books Explorer
//
//  Created by Hamid on 10/20/24.
//

import Foundation

// MARK: - BookResponse
struct BookResponse: Codable {
    let kind: String
    let totalItems: Int
    let items: [Book]?
}

// MARK: - Book
struct Book: Codable, Identifiable {
    let id: String
    let volumeInfo: VolumeInfo
}

// MARK: - VolumeInfo
struct VolumeInfo: Codable {
    let title, publishedDate: String?
    let imageLinks: ImageLinks?
    let authors: [String]?
    let publisher: String?
    let pageCount: Int?
    let language: String?
    let contentVersion: String?
    let description: String?
}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String?
}

// MARK: - Mock Response
extension BookResponse {
    static let bookResponse: BookResponse = {
        guard let url = Bundle.main.url(forResource: "search", withExtension: "json") else {
            fatalError("Unable to Find Stub Data")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Unable to Load Stub Data")
        }

        return try! JSONDecoder().decode(BookResponse.self, from: data)
    }()
}
