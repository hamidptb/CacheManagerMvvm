import Foundation

enum AppError: LocalizedError {
    case network(APIError)
    case cache(CacheError)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .network(let apiError):
            return apiError.errorDescription
        case .cache(let cacheError):
            return cacheError.errorDescription
        case .unknown(let error):
            return error.localizedDescription
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .network(let apiError):
            return apiError.recoverySuggestion
        case .cache(let cacheError):
            return "Try refreshing the data"
        case .unknown:
            return "Please try again later"
        }
    }
} 