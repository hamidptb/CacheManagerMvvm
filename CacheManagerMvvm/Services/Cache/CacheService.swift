//
//  CacheService.swift
//  CacheManagerMvvm
//
//  Created by Hamid on 11/26/24.
//

protocol CacheService {
    func save<T: Codable>(_ object: T, forKey key: String, expiration: CacheExpiration)
    func get<T: Codable>(forKey key: String) -> T?
    func removeObject(forKey key: String)
    func clearCache()
    func clearExpiredCache()
}
