//
//  LoginViewController.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 11/9/24.
//

import UIKit

class LoginViewController: UIViewController {
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    @IBAction func loginButton(_ sender: Any) {
        let heroesViewController = HeroesViewController()
        self.show(heroesViewController, sender: self)
    }
}
