import SwiftUI

struct ItemsListView: View {
    @StateObject private var viewModel = ItemsViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
//                ErrorView(message: error, retryAction: viewModel.fetchItems)
            } else {
                List(viewModel.items) { item in
                    ItemRow(item: item)
                }
            }
        }
        .navigationTitle("Items")
        .onAppear {
            viewModel.fetchItems()
        }
    }
}

struct ItemRow: View {
    let item: Item
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.headline)
            Text(item.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
} 
