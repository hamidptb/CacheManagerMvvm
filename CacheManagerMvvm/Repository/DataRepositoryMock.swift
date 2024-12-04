//
//  DataRepositoryMock.swift
//  CacheManagerMvvm
//
//  Created by Hamid on 11/26/24.
//

import Combine

class DataRepositoryMock: DataRepositoryProtocol {
    private let networkService: NetworkService
    private let cacheService: CacheService
    
    init(networkService: NetworkService = NetworkManagerMock(),
         cacheService: CacheService = CacheManagerMock()) {
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
    
    func getBooks(query: String, startIndex: Int, maxResults: Int, forceCache: Bool? = nil, forceUpdate: Bool? = nil) -> AnyPublisher<BookResponse, AppError> {
        fetch(endpoint: .books(query: query, startIndex: startIndex, maxResults: maxResults), forceCache: forceCache, forceUpdate: forceUpdate)
    }
}

/*
 // In a view model or repository test
 let mockCache = CacheManagerMock()
 mockCache.preloadData()
 let repository = DataRepository(networkService: NetworkManagerMock(), cacheService: mockCache)

 // Or in a preview
 struct ProductsView_Previews: PreviewProvider {
     static var previews: some View {
         let mockCache = CacheManagerMock()
         mockCache.preloadData()
         let repository = DataRepository(networkService: NetworkManagerMock(), cacheService: mockCache)
         return ProductsView(viewModel: ProductsViewModel(repository: repository))
     }
 }
 */
