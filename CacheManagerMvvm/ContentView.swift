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
                ProductsView(viewModel: ProductsViewModel(repository: DataRepository()))
            }
            .tabItem {
                Label("Products", systemImage: "cart")
            }
            
            NavigationView {
                UsersView(viewModel: UsersViewModel(repository: DataRepository()))
            }
            .tabItem {
                Label("Users", systemImage: "person.2")
            }
            
            NavigationView {
                BooksView(viewModel: BooksViewModel(repository: DataRepository()))
            }
            .tabItem {
                Label("Books", systemImage: "book")
            }
        }
    }
}
