import Foundation
import Combine

class BooksViewModel: ObservableObject {
    // MARK: - Properties
    
    @Published var books: [Book] = []
    @Published private(set) var isLoading = false
    @Published var error: AppError?
    @Published var searchText: String = ""
    
    @Published var hasMorePages = true
    private var currentPage = 0
//    private let pageSize = 10
    
    // MARK: - Dependencies
    private let repository: DataRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(repository: DataRepositoryProtocol) {
        self.repository = repository
        
        fetchBooks()
    }
    
    // MARK: - Helper Methods
    
    private func clearBooksCache() {
        // Clear all cached book pages
        let cacheService = (repository as? DataRepository)?.cacheService
        
        // Get all cache keys and remove those related to books
        if let cacheManager = cacheService as? CacheManager {
            let allKeys = UserDefaults.standard.dictionaryRepresentation().keys
            let booksCacheKeys = allKeys.filter { $0.starts(with: "cached_books_") }
            booksCacheKeys.forEach { cacheManager.removeObject(forKey: $0) }
        }
    }
    
    func refresh() {
        clearBooksCache() // Clear all cached book pages
        currentPage = 0
        hasMorePages = true
        books.removeAll()
        fetchBooks(forceUpdate: true) // Force fetch from network
    }
    
    func fetchBooks(forceCache: Bool? = nil, forceUpdate: Bool? = nil) {
        guard !isLoading && hasMorePages else { return }
        
        isLoading = true
//        error = nil
        
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "all" : searchText
        
        let startIndex = currentPage * Environment.defaultMaxResult
        
        repository.getBooks(query: query, startIndex: startIndex, maxResults: Environment.defaultMaxResult, forceCache: forceCache, forceUpdate: forceUpdate)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .finished:
                    print("Successfully Fetched Books")
                case .failure(let error):
                    print("Unable to Fetch Books: \(error)")
                    self?.error = error
                }
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                
                self.books.append(contentsOf: value.items ?? [])
                self.currentPage += 1
                self.hasMorePages = (self.books.count) < value.totalItems
            })
            .store(in: &cancellables)
    }
} 
