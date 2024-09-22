//
//  LoginViewController.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 11/9/24.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Actions
    @IBAction func loginButton(_ sender: Any) {
        guard let errorMessage = validateFields() else {
            loginProcess()
            return
        }
        showAlert(message: errorMessage)
    }
}

// MARK: - UI Configuration
extension LoginViewController {
    
    private func configureUI() {
        emailTextField.placeholder = "Enter your email"
        passwordTextField.placeholder = "Enter your password"
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Validation
extension LoginViewController {
    
    private func validateFields() -> String? {
        var errorMessage: [String] = []
        
        if let email = emailTextField.text, email.isEmpty {
            errorMessage.append("Email is empty")
        }
        if let password = passwordTextField.text, password.isEmpty {
            errorMessage.append("Password is empty")
        }
        return errorMessage.isEmpty ? nil : errorMessage.joined(separator: "\n")
    }
}

// MARK: - Networking
extension LoginViewController {
    
    private func loginProcess() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        NetworkModel.shared.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    self?.saveTokenAndNavigate(token: token)
                case .failure(let error):
                    print("Login failed with error: \(error)")
                    self?.passwordTextField.text = ""
                    self?.showAlert(message: "Login failed")
                }
            }
        }
    }
    
    private func saveTokenAndNavigate(token: String) {
        LocalDataModel.save(value: token)
        
        let heroesViewController = HeroesTableViewController()
        navigationController?.setViewControllers([heroesViewController], animated: true)
    }
}
