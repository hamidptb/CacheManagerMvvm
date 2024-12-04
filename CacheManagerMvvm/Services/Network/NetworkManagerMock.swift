//
//  NetworkManagerMock.swift
//  CacheManagerMvvm
//
//  Created by Hamid on 11/26/24.
//

import Foundation
import Combine

class NetworkManagerMock: NetworkService {
    
    // MARK: - NetworkService Protocol
    
    func fetchData<T: Decodable>(from endpoint: APIEndpoint) -> AnyPublisher<T, AppError> {
        publisher(for: mockFileName(for: endpoint))
    }
    
    // MARK: - Private Methods
    
    private func publisher<T: Decodable>(for resource: String) -> AnyPublisher<T, AppError> {
        Just(stubData(for: resource))
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .setFailureType(to: AppError.self)
            .eraseToAnyPublisher()
    }
    
    private func stubData<T: Decodable>(for resource: String) -> T {
        guard
            let url = Bundle.main.url(forResource: resource, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let stubData = try? JSONDecoder().decode(T.self, from: data)
        else {
            fatalError("Unable to load mock data for resource: \(resource)")
        }
        
        return stubData
    }
    
    private func mockFileName(for endpoint: APIEndpoint) -> String {
        switch endpoint {
        case .items:
            return "mock_items"
        case .products:
            return "mock_products"
        case .users:
            return "mock_users"
        case .books:
            return "mock_books"
        }
    }
}
