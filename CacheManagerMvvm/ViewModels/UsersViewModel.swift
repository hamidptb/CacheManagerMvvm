import Foundation
import Combine

class UsersViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var users: [User] = []
    
    @Published private(set) var isLoading = false
    
    @Published private(set) var errorMessage: String?
    
    // MARK: - Dependencies
    
    private let repository: DataRepositoryProtocol
    
    // MARK: - Subscription Management
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(repository: DataRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Helper Methods
    
    func fetchUsers(forceCache: Bool? = nil, forceUpdate: Bool? = nil) {
        isLoading = true
        
        repository.getUsers(forceCache: forceCache, forceUpdate: forceUpdate)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .finished:
                    print("Successfully Fetched Books")
                case .failure(let error):
                    print("Unable to Fetch Books \(error)")
                    
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                
                self.users = value
            }).store(in: &cancellables)
    }
}
