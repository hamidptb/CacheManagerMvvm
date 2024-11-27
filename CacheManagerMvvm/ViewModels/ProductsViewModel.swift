import Foundation
import Combine

class ProductsViewModel: ObservableObject {

    // MARK: - Properties
    
    @Published var products: [Product] = []
    
    @Published private(set) var isLoading = false
    
    @Published var errorMessage: String?
    
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
        
        repository.getProducts(forceCache: forceCache, forceUpdate: forceUpdate)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .finished:
                    print("Successfully Fetched Products")
                case .failure(let error):
                    print("Unable to Fetch Products: \(error)")
                    
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                
                self.products = value.products
            }).store(in: &cancellables)
    }
}
