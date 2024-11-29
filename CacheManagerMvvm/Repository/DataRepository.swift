import Foundation
import Combine

class DataRepository: DataRepositoryProtocol {
    private let networkService: NetworkService
    private let cacheService: CacheService
    
    init(networkService: NetworkService = NetworkManager(),
         cacheService: CacheService = CacheManager()) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    private func fetchFromNetwork<T: Codable>(endpoint: APIEndpoint) -> AnyPublisher<T, AppError> {
        networkService.fetchData(from: endpoint)
            .map { (data: T) -> T in
                self.cacheService.save(data,
                                     forKey: CacheConfig.shared.cacheKey(for: endpoint),
                                     expiration: CacheConfig.shared.cacheExpiration(for: endpoint))
                return data
            }
            .eraseToAnyPublisher()
    }
    
    private func fetch<T: Codable>(endpoint: APIEndpoint, 
                                  forceCache: Bool? = nil,
                                  forceUpdate: Bool? = nil) -> AnyPublisher<T, AppError> {
        // Force update: Skip cache and fetch from network
        if forceUpdate == true {
            return fetchFromNetwork(endpoint: endpoint)
        }
        
        // Force cache: Only try cache, fail if not found
        if forceCache == true {
            if let cachedData: T = cacheService.get(forKey: CacheConfig.shared.cacheKey(for: endpoint)) {
                return Just(cachedData)
                    .setFailureType(to: AppError.self)
                    .eraseToAnyPublisher()
            } else {
                return Fail(error: AppError.cache(.notFound))
                    .eraseToAnyPublisher()
            }
        }
        
        // Normal flow: Try cache first, then network
        if let cachedData: T = cacheService.get(forKey: CacheConfig.shared.cacheKey(for: endpoint)) {
            return Just(cachedData)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        }
        
        return fetchFromNetwork(endpoint: endpoint)
    }
    
    func getProducts(forceCache: Bool? = nil, forceUpdate: Bool? = nil) -> AnyPublisher<ProductResponse, AppError> {
        fetch(endpoint: .products, forceCache: forceCache, forceUpdate: forceUpdate)
    }
    
    func getUsers(forceCache: Bool? = nil, forceUpdate: Bool? = nil) -> AnyPublisher<[User], AppError> {
        fetch(endpoint: .users, forceCache: forceCache, forceUpdate: forceUpdate)
    }
}
