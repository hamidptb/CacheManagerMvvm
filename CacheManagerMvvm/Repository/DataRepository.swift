import Foundation
import Combine

protocol DataRepositoryProtocol {
    func getItems(forceCache: Bool?, forceUpdate: Bool?) -> AnyPublisher<[Item], Error>
    func getProducts(forceCache: Bool?, forceUpdate: Bool?) -> AnyPublisher<[Product], Error>
    func getUsers(forceCache: Bool?, forceUpdate: Bool?) -> AnyPublisher<[User], Error>
}

class DataRepository: DataRepositoryProtocol {
    private let networkService: NetworkService
    private let cacheService: CacheService
    
    init(networkService: NetworkService = NetworkManager(),
         cacheService: CacheService = CacheManager()) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    private func fetchFromNetwork<T: Codable>(endpoint: APIEndpoint) -> AnyPublisher<T, Error> {
        networkService.fetchData(from: endpoint)
            .map { (data: T) -> T in
                self.cacheService.save(data,
                                     forKey: CacheConfig.shared.cacheKey(for: endpoint),
                                     expiration: CacheConfig.shared.cacheExpiration(for: endpoint))
                return data
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    private func fetch<T: Codable>(endpoint: APIEndpoint, 
                                  forceCache: Bool? = nil,
                                  forceUpdate: Bool? = nil) -> AnyPublisher<T, Error> {
        // Force update: Skip cache and fetch from network
        if forceUpdate == true {
            return fetchFromNetwork(endpoint: endpoint)
        }
        
        // Force cache: Only try cache, fail if not found
        if forceCache == true {
            if let cachedData: T = cacheService.get(forKey: CacheConfig.shared.cacheKey(for: endpoint)) {
                return Just(cachedData)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: CacheError.notFound)
                    .eraseToAnyPublisher()
            }
        }
        
        // Normal flow: Try cache first, then network
        if let cachedData: T = cacheService.get(forKey: CacheConfig.shared.cacheKey(for: endpoint)) {
            return Just(cachedData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return fetchFromNetwork(endpoint: endpoint)
    }
    
    func getItems(forceCache: Bool? = nil, forceUpdate: Bool? = nil) -> AnyPublisher<[Item], Error> {
        fetch(endpoint: .items, forceCache: forceCache, forceUpdate: forceUpdate)
    }
    
    func getProducts(forceCache: Bool? = nil, forceUpdate: Bool? = nil) -> AnyPublisher<[Product], Error> {
        fetch(endpoint: .products, forceCache: forceCache, forceUpdate: forceUpdate)
    }
    
    func getUsers(forceCache: Bool? = nil, forceUpdate: Bool? = nil) -> AnyPublisher<[User], Error> {
        fetch(endpoint: .users, forceCache: forceCache, forceUpdate: forceUpdate)
    }
}

// Add a custom error type for cache-related errors
enum CacheError: LocalizedError {
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Data not found in cache"
        }
    }
} 