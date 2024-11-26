import Foundation
import Combine

class ItemsViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let repository: DataRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: DataRepositoryProtocol = DataRepository()) {
        self.repository = repository
    }
    
    func fetchItems(forceCache: Bool? = nil, forceUpdate: Bool? = nil) {
        isLoading = true
        error = nil
        
        repository.getItems(forceCache: forceCache, forceUpdate: forceUpdate)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] items in
                self?.items = items
            }
            .store(in: &cancellables)
    }
} 