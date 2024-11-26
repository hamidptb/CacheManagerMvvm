import Foundation

struct Item: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
} 