import Foundation
import Combine

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidUrl
    case noData
    case decodingError
    case serverError(Int)
    case unknown(Error)
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let baseUrl = "http://localhost:8080/api" // Base URL for the server

    func request<T: Decodable>(_ endpoint: String, method: HTTPMethod = .get, body: Data? = nil) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            return Fail(error: .invalidUrl).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    throw NetworkError.serverError(response.statusCode)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return .decodingError
                } else if let error = error as? NetworkError {
                    return error
                } else {
                    return .unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
