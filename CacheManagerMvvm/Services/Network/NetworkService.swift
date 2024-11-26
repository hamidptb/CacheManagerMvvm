//
//  NetworkService.swift
//  CacheManagerMvvm
//
//  Created by Hamid on 11/26/24.
//

import Combine

protocol NetworkService {
    
    func fetchData<T: Decodable>(from endpoint: APIEndpoint) -> AnyPublisher<T, APIError>
    
}
