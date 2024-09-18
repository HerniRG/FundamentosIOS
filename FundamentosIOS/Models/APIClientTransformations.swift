//
//  APIClientTransformations.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 18/9/24.
//

import Foundation

protocol APIClientTransformationsProtocol {
    var session: URLSession { get }
    func requestTransformations(
        _ request: URLRequest,
        completion: @escaping (Result<[Transformation], APIError>) -> Void
    )
}

struct APIClientTransformations: APIClientTransformationsProtocol {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func requestTransformations(
        _ request: URLRequest,
        completion: @escaping (Result<[Transformation], APIError>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            let result: Result<[Transformation], APIError>
            
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
            
            do {
                let transformations = try JSONDecoder().decode([Transformation].self, from: data)
                result = .success(transformations)
            } catch {
                result = .failure(.decodingFailed)
            }
        }
        
        task.resume()
    }
}
