import SwiftUI

struct UsersView: View {
    @ObservedObject var viewModel: UsersViewModel
    
    @State private var showingAlert = false
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else {
                List(viewModel.users) { user in
                    UserRow(user: user)
                }
            }
        }
        .navigationTitle("Users")
        .alert("Something went wrong", isPresented: $showingAlert) {
            Button("Retry", role: .none) {
                viewModel.fetchUsers()
            }
            Button("OK", role: .cancel) {
            }
        }
        .onAppear {
            viewModel.fetchUsers()
        }
    }
}

struct UserRow: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(user.name)
                .font(.headline)
            Text(user.email)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(user.address.street)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        // Example of using a mock cache to preload data for testing:
        // Uncomment the following lines if you want to simulate mock cached data.
        // let mockCache = CacheManagerMock()
        // mockCache.preloadData()
        // let repository = DataRepository(networkService: NetworkManagerMock(), cacheService: mockCache)
        // return UsersView(viewModel: UsersViewModel(repository: repository))
        
        // Using a mock repository for a simpler preview setup: (that reads data from mock JSON files in real-time)
        return UsersView(viewModel: UsersViewModel(repository: DataRepositoryMock()))
    }
}
