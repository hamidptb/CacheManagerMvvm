import Foundation
import Combine

class UsersViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var users: [User] = []
    
    @Published private(set) var isLoading = false
    
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
    
    func fetchUsers(forceCache: Bool? = nil, forceUpdate: Bool? = nil) {
        isLoading = true
        error = nil
        
        repository.getUsers(forceCache: forceCache, forceUpdate: forceUpdate)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .finished:
                    print("Successfully Fetched Users")
                case .failure(let error):
                    print("Unable to Fetch Users: \(error)")
                    self?.error = error as? AppError ?? .unknown(error)
                }
            }, receiveValue: { [weak self] value in
                self?.users = value
            }).store(in: &cancellables)
    }
}
