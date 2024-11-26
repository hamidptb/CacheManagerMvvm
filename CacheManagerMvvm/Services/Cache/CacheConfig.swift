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
        }
    }
    
    func cacheExpiration(for endpoint: APIEndpoint) -> CacheExpiration {
        switch endpoint {
        case .items:
            return .minutes(30)    // Cache items for 30 minutes
        case .products:
            return .hours(1)       // Cache products for 1 hour
        case .users:
            return .days(1)        // Cache users for 1 day
        }
    }
} 
