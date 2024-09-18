//
//  APIClienteHeroes.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 18/9/24.
//

import Foundation

protocol APIClientHeroesProtocol {
    var session: URLSession { get }
    func requestHeroes(
        _ request: URLRequest,
        completion: @escaping (Result<[Hero], APIError>) -> Void
    )
}

struct APIClientHeroes: APIClientHeroesProtocol {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func requestHeroes(
        _ request: URLRequest,
        completion: @escaping (Result<[Hero], APIError>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            let result: Result<[Hero], APIError>
            
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
                let heroes = try JSONDecoder().decode([Hero].self, from: data)
                result = .success(heroes)
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                result = .failure(.decodingFailed)
            }
        }
        
        task.resume()
    }
}
