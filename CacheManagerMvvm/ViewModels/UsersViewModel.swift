import Foundation
import Combine

class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let repository: DataRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: DataRepositoryProtocol = DataRepository()) {
        self.repository = repository
    }
    
    func fetchUsers(forceCache: Bool? = nil, forceUpdate: Bool? = nil) {
        isLoading = true
        error = nil
        
        repository.getUsers(forceCache: forceCache, forceUpdate: forceUpdate)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] users in
                self?.users = users
            }
            .store(in: &cancellables)
    }
} 
