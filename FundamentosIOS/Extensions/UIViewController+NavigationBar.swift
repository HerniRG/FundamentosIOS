//
//  UIViewController+NavigationBar.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 24/9/24.
//

import UIKit

extension UIViewController {

// MARK: - NavigationBar Configuration Extension
    func configureNavigationBar(title: String?, backgroundColor: UIColor) {
        self.title = title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.shadowColor = UIColor.black
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
    }
}
