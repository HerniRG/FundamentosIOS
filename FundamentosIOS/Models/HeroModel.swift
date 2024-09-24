//
//  HeroModel.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 13/9/24.
//

import Foundation

struct Hero: Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let photo: String
    let favorite: Bool
}
