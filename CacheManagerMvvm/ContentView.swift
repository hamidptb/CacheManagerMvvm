//
//  ContentView.swift
//  CacheManagerMvvm
//
//  Created by Hamid on 11/24/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                ItemsListView()
            }
            .tabItem {
                Label("Items", systemImage: "list.bullet")
            }
            
            NavigationView {
                ProductsView()
            }
            .tabItem {
                Label("Products", systemImage: "cart")
            }
            
            NavigationView {
                UsersView()
            }
            .tabItem {
                Label("Users", systemImage: "person.2")
            }
        }
    }
}
