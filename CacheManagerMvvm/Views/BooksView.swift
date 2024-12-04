import SwiftUI

struct BooksView: View {
    @ObservedObject var viewModel: BooksViewModel
    
    var body: some View {
        ZStack {
            if viewModel.books.isEmpty && !viewModel.isLoading {
                Text("No results found")
                    .foregroundColor(.gray)
                    .font(.headline)
            } else if let error = viewModel.error {
                ErrorView(error: error) {
                    viewModel.error = nil
                    viewModel.refresh()
                }
            } else {
                booksList
            }
            
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(.circular)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(16)
            }
        }
        .navigationTitle("Books")
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onSubmit(of: .search) {
            viewModel.refresh()
        }
        // Handle cancel tapped in search bar
        .onChange(of: viewModel.searchText) {
            if viewModel.searchText.isEmpty {
                viewModel.searchText = ""
                viewModel.refresh()
            }
        }
    }
    
    private var booksList: some View {
        List {
            ForEach(viewModel.books) { book in
                BookRow(book: book)
                // Pagination
                    .onAppear {
                        if book.id == viewModel.books.last?.id {
                            viewModel.fetchBooks()
                        }
                    }
            }
        }
        .refreshable {
            viewModel.refresh()
        }
    }
}

struct BookRow: View {
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(book.volumeInfo.title ?? "-")
                .font(.headline)
            
            Text(book.volumeInfo.authors?.joined(separator: ", ") ?? "-")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(book.volumeInfo.description ?? "-")
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(3)
        }
        .padding(.vertical, 4)
    }
}

struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BooksView(viewModel: BooksViewModel(repository: DataRepositoryMock()))
        }
    }
}
