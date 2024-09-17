//
//  TransformationModel.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 17/9/24.
//

import Foundation

// Modelo para una transformación
struct Transformation: Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let photo: String
}
