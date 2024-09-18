//
//  APIClienteLogin.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 18/9/24.
//

import Foundation

enum APIError: Error {
    case noData
    case decodingFailed
    case statusCode(code: Int?)
    case unknown
}

protocol APIClientLoginProtocol {
    var session: URLSession { get }
    func requestLogin(
        _ request: URLRequest,
        completion: @escaping (Result<String, APIError>) -> Void
    )
}

struct APIClientLogin: APIClientLoginProtocol {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func requestLogin(
        _ request: URLRequest,
        completion: @escaping (Result<String, APIError>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            let result: Result<String, APIError>
            
            defer {
                completion(result)
            }
            
            if let error = error {
                print("Request error: \(error.localizedDescription)")
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
            
            if let token = String(data: data, encoding: .utf8) {
                result = .success(token)
            } else {
                result = .failure(.decodingFailed)
            }
        }
        
        task.resume()
    }
}
