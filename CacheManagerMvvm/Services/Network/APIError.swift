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
    
    var errorDescription: String {
        switch self {
        case .unauthorized:
            return "Authentication required"
        case .unreachable:
            return "No internet connection"
        case .failedRequest:
            return "Failed to load data"
        case .invalidResponse:
            return "Invalid server response"
        case .unknown:
            return "An unknown error occurred"
        case .tooManyRequests:
            return "Too many requests"
        case .badRequest:
            return "Invalid request"
        case .forbidden:
            return "Access denied"
        }
    }
    
    var recoverySuggestion: String {
        switch self {
        case .unauthorized:
            return "Please log in again"
        case .unreachable:
            return "Please check your internet connection"
        case .failedRequest, .invalidResponse:
            return "Please try again"
        case .unknown:
            return "Please try again later"
        case .tooManyRequests:
            return "Please wait a moment before trying again"
        case .badRequest:
            return "Please check your input"
        case .forbidden:
            return "You don't have permission to access this resource"
        }
    }
}
