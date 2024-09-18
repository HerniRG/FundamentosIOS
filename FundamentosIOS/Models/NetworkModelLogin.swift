//
//  NetworkModelLogin.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 18/9/24.
//

import Foundation

final class NetworkModelLogin {
    static let shared = NetworkModelLogin()
    
    private let client: APIClientLoginProtocol
    
    // Inicializa el cliente con el protocolo APIClientLoginProtocol
    private init(client: APIClientLoginProtocol = APIClientLogin()) {
        self.client = client
    }
    
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<String, APIError>) -> Void
    ) {
        // URL para el login
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/auth/login") else {
            completion(.failure(.unknown))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Codificar las credenciales en base64
        let loginString = "\(email):\(password)"
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(.unknown))
            return
        }
        
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // Realizar la solicitud de login con el cliente de API
        client.requestLogin(request, completion: completion)
    }
}
