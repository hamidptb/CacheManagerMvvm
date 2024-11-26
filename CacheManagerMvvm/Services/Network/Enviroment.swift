//
//  Enviroment.swift
//  CacheManagerMvvm
//
//  Created by Hamid on 11/25/24.
//

import Foundation

enum Environment {

    static var apiBaseURL: URL {
        URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    static var defaultMaxResult: Int {
        10
    }
}
