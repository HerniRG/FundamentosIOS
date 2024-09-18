//
//  NetworkModelTransformations.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 18/9/24.
//

import Foundation

final class NetworkModelTransformations {
    static let shared = NetworkModelTransformations()
    
    private let client: APIClientTransformationsProtocol
    
    private init(client: APIClientTransformationsProtocol = APIClientTransformations()) {
        self.client = client
    }
    
    func fetchTransformations(
        heroId: String,
        completion: @escaping (Result<[Transformation], APIError>) -> Void
    ) {
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/heros/tranformations") else {
            completion(.failure(.unknown))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            completion(.failure(.unknown))
            return
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = ["id": heroId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        client.requestTransformations(request, completion: completion)
    }
}
