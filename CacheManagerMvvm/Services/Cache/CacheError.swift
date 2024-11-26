//
//  CacheError.swift
//  CacheManagerMvvm
//
//  Created by Hamid on 11/26/24.
//

import Foundation

enum CacheError: LocalizedError {
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Data not found in cache"
        }
    }
} 
