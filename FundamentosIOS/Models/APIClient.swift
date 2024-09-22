//
//  APIClient.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 22/9/24.
//

import Foundation

enum APIError: Error, Equatable {
    case noData
    case decodingFailed
    case statusCode(code: Int?)
    case unknown
}

protocol APIClientProtocol {
    var session: URLSession { get }
    func request<T: Codable>(
        _ type: T.Type,
        from request: URLRequest,
        completion: @escaping (Result<T, APIError>) -> Void
    )
}

struct APIClient: APIClientProtocol {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Codable>(
        _ type: T.Type,
        from request: URLRequest,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            let result: Result<T, APIError>
            
            defer {
                completion(result)
            }
            
            if error != nil {
                result = .failure(.unknown)
                return
            }
            
            guard let data = data else {
                result = .failure(.noData)
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode == 200 else {
                result = .failure(.statusCode(code: statusCode))
                return
            }
            
            // Si esperamos un String como en el caso del token, devolvemos el String sin decodificar
            if T.self == String.self, let token = String(data: data, encoding: .utf8) as? T {
                result = .success(token)
                return
            }
            
            // Intentar decodificar el objeto esperado en el resto de casos
            do {
                let decodedObject = try JSONDecoder().decode(type.self, from: data)
                result = .success(decodedObject)
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                result = .failure(.decodingFailed)
            }
        }
        
        task.resume()
    }
}

