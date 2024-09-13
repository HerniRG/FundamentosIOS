//
//  HeroModel.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 13/9/24.
//

import Foundation


struct Hero: Decodable, Hashable {
    
    let id, description, name : String
    let photo: URL
    let favorite: Bool
}
