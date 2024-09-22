//
//  APIClientProtocolMock.swift
//  FundamentosIOSTests
//
//  Created by Hernán Rodríguez on 22/9/24.
//

import Foundation
@testable import FundamentosIOS

final class APIClientProtocolMock<C: Codable>: APIClientProtocol {
    var session: URLSession = .shared
    
    var didCallRequest = false
    var receivedRequest: URLRequest?
    var receivedResult: Any? // acepto cualquier tipo me daba error en los test
    
    func request<T: Codable>(
        _ type: T.Type,
        from request: URLRequest,
        completion: @escaping (Result<T, FundamentosIOS.APIError>) -> Void
    ) {
        receivedRequest = request
        didCallRequest = true
        
        if let result = receivedResult as? Result<T, FundamentosIOS.APIError>{
            completion(result)
        }
    }
}
