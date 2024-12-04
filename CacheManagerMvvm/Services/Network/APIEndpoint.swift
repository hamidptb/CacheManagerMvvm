import Foundation

enum APIEndpoint {
    case items
    case products
    case users
    case books(query: String, startIndex: Int, maxResults: Int)
    
    func request() throws -> URLRequest {
        var request = URLRequest(url: url)

        request.addHeaders(headers)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpBody

        return request
    }
    
    private var url: URL {
        let baseURL: URL

        switch self {
        case .items, .users:
            baseURL = Environment.apiBaseURLJsonplaceholder
        case .products:
            baseURL = Environment.apiBaseURLDummyjson
        case .books:
            baseURL = Environment.apiBaseURLGoogleBooks
        }

        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        components.queryItems = params
        return components.url!
    }
    
    private var path: String {
        switch self {
        case .items:
            return "/items"
        case .products:
            return "/products"
        case .users:
            return "/users"
        case .books:
            return "/books/v1/volumes"
        }
    }
    
    private var params: [URLQueryItem]? {
        switch self {
        case .items, .products, .users:
            return nil
        case .books(let query, let startIndex, let maxResults):
            return [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "startIndex", value: String(startIndex)),
                URLQueryItem(name: "maxResults", value: String(maxResults))
            ]
        }
    }
    
    private var httpMethod: HTTPMethod {
        switch self {
        case .items, .products, .users, .books:
            return .get
        }
    }

    private var httpBody: Data? {
        switch self {
        case .items, .products, .users, .books:
            return nil
        }
    }
    
    private var headers: Headers {
        switch self {
        case .items, .products, .users, .books:
            return ["Content-Type": "application/json"]
        }
    }
}

extension URLRequest {

    mutating func addHeaders(_ headers: Headers) {
        headers.forEach { header, value in
            addValue(value, forHTTPHeaderField: header)
        }
    }

}
