import Foundation
import Combine

class NetworkManager: NetworkService {
    
    func fetchData<T: Decodable>(from endpoint: APIEndpoint) -> AnyPublisher<T, AppError> {
        do {
            // Generate the URLRequest from the endpoint
            let request = try endpoint.request()

            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { data, response -> T in
                    // Log the response data (optional)
                    print(String(decoding: data, as: UTF8.self))

                    // Validate HTTP response status
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw APIError.invalidResponse
                    }
                    let statusCode = httpResponse.statusCode

                    switch statusCode {
                    case 200..<300:
                        break // Proceed with decoding
                    case 400:
                        throw APIError.badRequest
                    case 401:
                        throw APIError.unauthorized
                    case 403:
                        throw APIError.forbidden
                    case 429:
                        throw APIError.tooManyRequests
                    default:
                        throw APIError.failedRequest
                    }

                    // Handle No Content response
                    if statusCode == 204, let noContent = NoContent() as? T {
                        return noContent
                    }

                    // Decode JSON into the expected type
                    do {
                        return try JSONDecoder().decode(T.self, from: data)
                    } catch {
                        print("Unable to Decode Response \(error)")
                        throw APIError.invalidResponse
                    }
                }
                .mapError { error -> AppError in
                    // Map to custom APIError
                    if let apiError = error as? APIError {
                        return .network(apiError)
                    }
                    switch error {
                    case URLError.notConnectedToInternet:
                        return .network(.unreachable)
                    default:
                        return .unknown(error)
                    }
                }
                .eraseToAnyPublisher()
        } catch {
            // Handle errors in creating the URLRequest
            if let apiError = error as? APIError {
                return Fail(error: .network(apiError)).eraseToAnyPublisher()
            } else {
                return Fail(error: .unknown(error)).eraseToAnyPublisher()
            }
        }
    }
}
