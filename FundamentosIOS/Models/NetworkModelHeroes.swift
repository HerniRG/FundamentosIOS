//
//  NetworkModelHeroes.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 18/9/24.
//

import Foundation

final class NetworkModelHeroes {
    
    static let shared = NetworkModelHeroes()
    
    private let client: APIClientHeroesProtocol
    
    // Inicializa el cliente con el protocolo APIClientHeroesProtocol
    private init(client: APIClientHeroesProtocol = APIClientHeroes()) {
        self.client = client
    }
    
    func fetchHeroes(completion: @escaping (Result<[Hero], APIError>) -> Void) {
        // URL de la API de héroes
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/heros/all") else {
            completion(.failure(.unknown))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Obtener el token de autenticación almacenado en UserDefaults
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            completion(.failure(.unknown))
            return
        }
        
        // Agregar el token de autorización al encabezado
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Cuerpo de la petición, aquí puedes ajustar los parámetros si necesitas
        let body: [String: Any] = ["name": ""]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        // Realizar la solicitud con el cliente de API
        client.requestHeroes(request, completion: completion)
    }
}
