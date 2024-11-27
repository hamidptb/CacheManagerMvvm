//
//  Enviroment.swift
//  CacheManagerMvvm
//
//  Created by Hamid on 11/25/24.
//

import Foundation

enum Environment {

    static var apiBaseURLJsonplaceholder: URL {
        URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    static var apiBaseURLDummyjson: URL {
        URL(string: "https://dummyjson.com")!
    }
    
    static var defaultMaxResult: Int {
        10
    }
}
