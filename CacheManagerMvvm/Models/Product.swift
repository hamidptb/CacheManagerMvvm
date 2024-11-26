import Foundation

struct Product: Codable, Identifiable {
    let id: Int
    let name: String
    let price: Double
    let description: String
} 