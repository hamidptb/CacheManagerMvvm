//
//  APIError.swift
//  CacheManagerMvvm
//
//  Created by Hamid on 11/26/24.
//

enum APIError: Error {
    case unauthorized
    case unreachable
    case failedRequest
    case invalidResponse
    case unknown
    case tooManyRequests
    case badRequest
    case forbidden
}
