import SwiftUI

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
//                ErrorView(message: error, retryAction: viewModel.fetchProducts)
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
            Text(product.name)
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
