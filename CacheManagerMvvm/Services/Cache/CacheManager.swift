import Foundation

struct CachedObject<T: Codable>: Codable {
    let object: T
    let timestamp: Date
    let expirationMinutes: Double?
    
    var isExpired: Bool {
        guard let expirationMinutes = expirationMinutes else { return false }
        let expirationInterval = TimeInterval(expirationMinutes * 60)
        return Date().timeIntervalSince(timestamp) > expirationInterval
    }
}

class CacheManager: CacheService {
    private let storage = UserDefaults.standard
    private var memoryCache = NSCache<NSString, CacheWrapper>()
    private var memoryCacheKeys = Set<String>() // Track memory cache keys
    
    init() {
        // Configure memory cache
        memoryCache.countLimit = 100 // Maximum number of objects
        memoryCache.totalCostLimit = 50 * 1024 * 1024 // 50MB limit
    }
    
    // Wrapper class for NSCache (since it doesn't accept structs)
    private class CacheWrapper {
        let data: Data
        let timestamp: Date
        let expirationMinutes: Double?
        
        init(data: Data, timestamp: Date, expirationMinutes: Double?) {
            self.data = data
            self.timestamp = timestamp
            self.expirationMinutes = expirationMinutes
        }
        
        var isExpired: Bool {
            guard let expirationMinutes = expirationMinutes else { return false }
            let expirationInterval = TimeInterval(expirationMinutes * 60)
            return Date().timeIntervalSince(timestamp) > expirationInterval
        }
    }
    
    func save<T: Codable>(_ object: T, forKey key: String, expiration: CacheExpiration = .never) {
        do {
            let cachedObject = CachedObject(object: object, 
                                          timestamp: Date(),
                                          expirationMinutes: expiration.minutes)
            let data = try JSONEncoder().encode(cachedObject)
            
            // Save to memory cache
            let wrapper = CacheWrapper(data: data, 
                                     timestamp: Date(),
                                     expirationMinutes: expiration.minutes)
            memoryCache.setObject(wrapper, forKey: key as NSString)
            memoryCacheKeys.insert(key) // Track the key
            
            // Save to persistent storage
            storage.set(data, forKey: key)
        } catch {
            print("Error saving to cache: \(error)")
        }
    }
    
    func get<T: Codable>(forKey key: String) -> T? {
        // First try memory cache
        if let wrapper = memoryCache.object(forKey: key as NSString) {
            if wrapper.isExpired {
                removeObject(forKey: key)
                return nil
            }
            
            do {
                let cachedObject = try JSONDecoder().decode(CachedObject<T>.self, from: wrapper.data)
                return cachedObject.object
            } catch {
                print("Error decoding from memory cache: \(error)")
            }
        }
        
        // If not in memory, try persistent storage
        guard let data = storage.data(forKey: key) else { return nil }
        do {
            let cachedObject = try JSONDecoder().decode(CachedObject<T>.self, from: data)
            
            // Check if cached object is expired
            if cachedObject.isExpired {
                removeObject(forKey: key)
                return nil
            }
            
            // Save back to memory cache for future use
            let wrapper = CacheWrapper(data: data, 
                                     timestamp: cachedObject.timestamp,
                                     expirationMinutes: cachedObject.expirationMinutes)
            memoryCache.setObject(wrapper, forKey: key as NSString)
            
            return cachedObject.object
        } catch {
            print("Error retrieving from persistent cache: \(error)")
            return nil
        }
    }
    
    func removeObject(forKey key: String) {
        // Remove from memory cache
        memoryCache.removeObject(forKey: key as NSString)
        memoryCacheKeys.remove(key) // Remove from tracking
        // Remove from persistent storage
        storage.removeObject(forKey: key)
    }
    
    func clearCache() {
        // Clear memory cache
        memoryCache.removeAllObjects()
        memoryCacheKeys.removeAll() // Clear tracking
        // Clear persistent storage
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
    
    func clearExpiredCache() {
        // Clear expired items from memory cache
        for key in memoryCacheKeys {
            if let wrapper = memoryCache.object(forKey: key as NSString), wrapper.isExpired {
                memoryCache.removeObject(forKey: key as NSString)
                memoryCacheKeys.remove(key)
            }
        }
        
        // Clear expired items from persistent storage
        let keys = storage.dictionaryRepresentation().keys
        for key in keys {
            if let data = storage.data(forKey: key) {
                do {
                    struct CacheMetadata: Codable {
                        let timestamp: Date
                        let expirationMinutes: Double?
                    }
                    
                    if let metadata = try? JSONDecoder().decode(CacheMetadata.self, from: data) {
                        let isExpired = metadata.expirationMinutes.map { minutes in
                            let expirationInterval = TimeInterval(minutes * 60)
                            return Date().timeIntervalSince(metadata.timestamp) > expirationInterval
                        } ?? false
                        
                        if isExpired {
                            removeObject(forKey: key)
                        }
                    }
                }
            }
        }
    }
} 
