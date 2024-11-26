import Foundation

enum APIEndpoint {
    case items
    case products
    case users
    
    func request() throws -> URLRequest {
        var request = URLRequest(url: url)

        request.addHeaders(headers)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpBody

        return request
    }
    
    private var url: URL {
        var components = URLComponents(url: Environment.apiBaseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
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
        }
    }
    
    private var params: [URLQueryItem]? {
        switch self {
        case .items, .products, .users:
            return nil
        }
    }
    
    private var httpMethod: HTTPMethod {
        switch self {
        case .items, .products, .users:
            return .get
        }
    }

    private var httpBody: Data? {
        switch self {
        case .items, .products, .users:
            return nil
        }
    }
    
    private var headers: Headers {
        switch self {
        case .items, .products, .users:
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
