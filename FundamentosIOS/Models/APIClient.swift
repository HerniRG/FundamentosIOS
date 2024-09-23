//
//  APIClient.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 22/9/24.
//

import Foundation

// Definimos los errores posibles
enum APIError: Error, Equatable {
    case noData
    case decodingFailed
    case statusCode(code: Int?)
    case unknown
}

// Definimos el protocolo para el APIClient
protocol APIClientProtocol {
    var session: URLSession { get }
    
    // Método para hacer login y obtener el token JWT
    func jwt(
        from request: URLRequest,
        completion: @escaping (Result<String, APIError>) -> Void
    )
    
    // Método genérico para hacer otras solicitudes
    func request<T: Codable>(
        _ type: T.Type,
        from request: URLRequest,
        completion: @escaping (Result<T, APIError>) -> Void
    )
}

// Implementación del APIClient
struct APIClient: APIClientProtocol {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    // Método específico para obtener el token JWT
    func jwt(
        from request: URLRequest,
        completion: @escaping (Result<String, APIError>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            let result: Result<String, APIError>
            
            defer {
                completion(result)
            }
            
            // Si ocurre un error en la solicitud
            if let error = error {
                print("Error en la petición JWT: \(error.localizedDescription)")
                result = .failure(.unknown)
                return
            }
            
            // Verificamos que hay datos en la respuesta
            guard let data = data else {
                result = .failure(.noData)
                return
            }
            
            // Comprobamos el código de estado HTTP
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode == 200 else {
                result = .failure(.statusCode(code: statusCode))
                return
            }
            
            // Intentamos obtener el token JWT como String
            if let token = String(data: data, encoding: .utf8) {
                result = .success(token)
            } else {
                result = .failure(.decodingFailed)
            }
        }
        
        task.resume()
    }

    // Método genérico para hacer peticiones que no sean de autenticación
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
            
            if let error = error {
                print("Error en la petición: \(error.localizedDescription)")
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
            
            // Intentamos decodificar el objeto esperado
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
