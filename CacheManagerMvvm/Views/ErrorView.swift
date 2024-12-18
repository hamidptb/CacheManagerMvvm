import SwiftUI

struct ErrorView: View {
    let error: AppError
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text(error.errorDescription ?? "An error occurred")
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if let recoverySuggestion = error.recoverySuggestion {
                Text(recoverySuggestion)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button(action: retryAction) {
                Text("Retry")
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
    }
} 