//
//  DataRepositoryProtocol.swift
//  CacheManagerMvvm
//
//  Created by Hamid on 11/26/24.
//

import Combine

protocol DataRepositoryProtocol {
    func getProducts(forceCache: Bool?, forceUpdate: Bool?) -> AnyPublisher<ProductResponse, AppError>
    func getUsers(forceCache: Bool?, forceUpdate: Bool?) -> AnyPublisher<[User], AppError>
    func getBooks(query: String, startIndex: Int, maxResults: Int, forceCache: Bool?, forceUpdate: Bool?) -> AnyPublisher<BookResponse, AppError>
}
