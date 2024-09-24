//
//  LocalDataModel.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 22/9/24.
//

import Foundation


struct LocalDataModel {
    private enum Constants {
        static let valueKey = "token"
    }
    private static let userDefaults = UserDefaults.standard
    
    static func get() -> String? {
        userDefaults.string(forKey: Constants.valueKey)
    }
    
    static func save(value: String) {
        userDefaults.set(value, forKey: Constants.valueKey)
    }
    
    static func delete() {
        userDefaults.removeObject(forKey: Constants.valueKey)
    }
}
