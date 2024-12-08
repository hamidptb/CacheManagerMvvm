import Foundation

final class CacheConfig {
    static let shared = CacheConfig()
    
    private init() {}
    
    func cacheKey(for endpoint: APIEndpoint) -> String {
        switch endpoint {
        case .items:
            return "cached_items"
        case .products:
            return "cached_products"
        case .users:
            return "cached_users"
        case .books(let query, let startIndex, _):
            return "cached_books_\(query)_\(startIndex)"
        }
    }
    
    func cacheExpiration(for endpoint: APIEndpoint) -> CacheExpiration {
        switch endpoint {
        case .items:
            return .minutes(30)
        case .products:
            return .hours(1)
        case .users:
            return .days(1)
        case .books:
            return .minutes(30)
        }
    }
} 
