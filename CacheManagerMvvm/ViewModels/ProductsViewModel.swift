import Foundation
import Combine

class ProductsViewModel: ObservableObject {

    // MARK: - Properties
    
    @Published var products: [Product] = []
    
    @Published private(set) var isLoading = false
    
    @Published var errorMessage: String?
    
    @Published var error: AppError?
    
    // MARK: - Dependencies
    
    private let repository: DataRepositoryProtocol
    
    // MARK: - Subscription Management
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(repository: DataRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Helper Methods
    
    func fetchProducts(forceCache: Bool? = nil, forceUpdate: Bool? = nil) {
        isLoading = true
        errorMessage = nil
        error = nil
        
        repository.getProducts(forceCache: forceCache, forceUpdate: forceUpdate)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .finished:
                    print("Successfully Fetched Products")
                case .failure(let error):
                    print("Unable to Fetch Products: \(error)")
                    self?.error = error
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] value in
                self?.products = value.products
            }).store(in: &cancellables)
    }
}
