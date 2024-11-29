import SwiftUI

struct ProductsView: View {
    @ObservedObject var viewModel: ProductsViewModel
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                ErrorView(error: error) {
                    viewModel.error = nil
                    viewModel.fetchProducts()
                }
            } else {
                List(viewModel.products) { product in
                    ProductRow(product: product)
                }
            }
        }
        .navigationTitle("Products")
        .onAppear {
            viewModel.fetchProducts()
        }
    }
}

struct ProductRow: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(product.title)
                .font(.headline)
            Text(product.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("$\(product.price, specifier: "%.2f")")
                .font(.caption)
                .foregroundColor(.blue)
        }
    }
} 

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        // Example of using a mock cache to preload data for testing:
        // Uncomment the following lines if you want to simulate mock cached data.
        // let mockCache = CacheManagerMock()
        // mockCache.preloadData()
        // let repository = DataRepository(networkService: NetworkManagerMock(), cacheService: mockCache)
        // return UsersView(viewModel: UsersViewModel(repository: repository))
        
        // Using a mock repository for a simpler preview setup: (that reads data from mock JSON files in real-time)
        return ProductsView(viewModel: ProductsViewModel(repository: DataRepositoryMock()))
    }
}

