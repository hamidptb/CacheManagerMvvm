import SwiftUI

struct UsersView: View {
    @StateObject private var viewModel = UsersViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
//                ErrorView(message: error, retryAction: viewModel.fetchUsers)
            } else {
                List(viewModel.users) { user in
                    UserRow(user: user)
                }
            }
        }
        .navigationTitle("Users")
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
