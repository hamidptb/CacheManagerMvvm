import Foundation
import Combine

class ProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let repository: DataRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: DataRepositoryProtocol = DataRepository()) {
        self.repository = repository
    }
    
    func fetchProducts(forceCache: Bool? = nil, forceUpdate: Bool? = nil) {
        isLoading = true
        error = nil
        
        repository.getProducts(forceCache: forceCache, forceUpdate: forceUpdate)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] products in
                self?.products = products
            }
            .store(in: &cancellables)
    }
} 