//
//  NetworkManager.swift
//  MVVMExample
//
//  Created by Luis Diego Ruiz Bautista on 7/07/23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case invalidData
    case invalidDecodeData
    case invalidEncodeData
}


class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }
    
    func request(urlString: String,
                 method: HTTPMethod = .get,
                 headers: [String: String]? = nil,
                 queryParams: [String: String]? = nil,
                 body: Data? = nil,
                 completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        
        guard var urlComponents = URLComponents(string: urlString) else {
               completion(.failure(.invalidURL))
               return
        }

        if let queryParams = queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}



