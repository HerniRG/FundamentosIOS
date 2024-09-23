//
//  NetworkModel.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 22/9/24.
//

import Foundation

final class NetworkModel {
    // Singleton de NetworkModel
    static let shared = NetworkModel()
    
    // Componente base para las URLs
    private var baseComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dragonball.keepcoding.education"
        return components
    }
    
    private let client: APIClientProtocol
    
    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    // MARK: - Login
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<String, APIError>) -> Void
    ) {
        // Crear la URL para el login
        var components = baseComponents
        components.path = "/api/auth/login"
        
        guard let url = components.url else {
            completion(.failure(.unknown))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Codificar las credenciales en Base64
        let loginString = "\(email):\(password)"
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(.unknown))
            return
        }
        
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // Realizar la solicitud de login con el cliente de API
        client.jwt(from: request, completion: completion)
    }
    
    // MARK: - Fetch Heroes
    func fetchHeroes(completion: @escaping (Result<[Hero], APIError>) -> Void) {
        // Crear la URL para obtener héroes
        var components = baseComponents
        components.path = "/api/heros/all"
        
        guard let url = components.url else {
            completion(.failure(.unknown))
            return
        }

        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        // Obtener el token de autenticación
        guard let token = LocalDataModel.get() else {
            completion(.failure(.unknown))
            return
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = ["name": ""]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        // Realizar la solicitud para obtener héroes
        client.request([Hero].self, from: request, completion: completion)
    }
    
    // MARK: - Fetch Transformations
    func fetchTransformations(
        heroId: String,
        completion: @escaping (Result<[Transformation], APIError>) -> Void
    ) {
        // Crear la URL para obtener transformaciones
        var components = baseComponents
        components.path = "/api/heros/tranformations"
        
        guard let url = components.url else {
            completion(.failure(.unknown))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Obtener el token de autenticación
        guard let token = LocalDataModel.get() else {
            completion(.failure(.unknown))
            return
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = ["id": heroId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        // Realizar la solicitud para obtener transformaciones
        client.request([Transformation].self, from: request, completion: completion)
    }
}
