import Foundation

class CacheManagerMock: CacheService {
    // In-memory storage for mocked cache
    private var mockStorage: [String: Any] = [:]
    private var mockExpirations: [String: Date] = [:]
    
    // MARK: - CacheService Protocol Methods
    
    func save<T: Codable>(_ object: T, forKey key: String, expiration: CacheExpiration) {
        mockStorage[key] = object
        
        // Set expiration if applicable
        if let minutes = expiration.minutes {
            mockExpirations[key] = Date().addingTimeInterval(minutes * 60)
        }
    }
    
    func get<T: Codable>(forKey key: String) -> T? {
        // Check expiration
        if let expirationDate = mockExpirations[key], Date() > expirationDate {
            removeObject(forKey: key)
            return nil
        }
        
        return mockStorage[key] as? T
    }
    
    func removeObject(forKey key: String) {
        mockStorage.removeValue(forKey: key)
        mockExpirations.removeValue(forKey: key)
    }
    
    func clearCache() {
        mockStorage.removeAll()
        mockExpirations.removeAll()
    }
    
    func clearExpiredCache() {
        let now = Date()
        let expiredKeys = mockExpirations.filter { $0.value < now }.map { $0.key }
        expiredKeys.forEach { removeObject(forKey: $0) }
    }
    
    // MARK: - Mock Specific Methods
    
    /// Preload mock data into the cache
    func preloadData() {
        // Example mock data
        let mockItems = [
            Item(id: 1, title: "Mock Item 1", description: "Description 1"),
            Item(id: 2, title: "Mock Item 2", description: "Description 2")
        ]
        
        let mockProducts = [
            Product(id: 1, name: "Mock Product 1", price: 99.99, description: "Product Description 1"),
            Product(id: 2, name: "Mock Product 2", price: 149.99, description: "Product Description 2")
        ]
        
        let mockUsers = [
            User(id: 1, 
                 name: "Mock User", 
                 username: "mockuser", 
                 email: "mock@example.com",
                 address: Address(street: "Mock Street",
                                suite: "Suite 1",
                                city: "Mock City",
                                zipcode: "12345",
                                geo: Geo(lat: "0", lng: "0")),
                 phone: "123-456-7890",
                 website: "mock.com",
                 company: Company(name: "Mock Co",
                                catchPhrase: "Mock Phrase",
                                bs: "Mock BS"))
        ]
        
        // Save mock data with appropriate cache keys
        save(mockItems, forKey: CacheConfig.shared.cacheKey(for: .items), expiration: .minutes(30))
        save(mockProducts, forKey: CacheConfig.shared.cacheKey(for: .products), expiration: .hours(1))
        save(mockUsers, forKey: CacheConfig.shared.cacheKey(for: .users), expiration: .days(1))
    }
} 
