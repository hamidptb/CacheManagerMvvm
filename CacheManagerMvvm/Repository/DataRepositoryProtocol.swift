//
//  DataRepositoryProtocol.swift
//  CacheManagerMvvm
//
//  Created by Hamid on 11/26/24.
//

import Combine

protocol DataRepositoryProtocol {
    func getItems(forceCache: Bool?, forceUpdate: Bool?) -> AnyPublisher<[Item], Error>
    func getProducts(forceCache: Bool?, forceUpdate: Bool?) -> AnyPublisher<[Product], Error>
    func getUsers(forceCache: Bool?, forceUpdate: Bool?) -> AnyPublisher<[User], Error>
}
