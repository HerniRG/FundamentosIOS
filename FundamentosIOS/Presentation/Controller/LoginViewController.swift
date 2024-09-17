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
            login()
            return
        }
        showAlert(message: errorMessage)
    }
}

extension LoginViewController {
    
    // MARK: - UI Configuration
    private func configureUI() {
        emailTextField.placeholder = "Enter your email"
        passwordTextField.placeholder = "Enter your password"
    }
    
    // MARK: - Error Handling
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Validation
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
    
    
    // MARK: - Login Process
    private func login() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/auth/login") else {
            showAlert(message: "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let loginString = "\(email):\(password)"
        guard let loginData = loginString.data(using: .utf8) else {
            showAlert(message: "Error encoding credentials")
            return
        }
        
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let data = data, error == nil, let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.clearFieldsAndShowError(message: "Login failed. Please try again.")
                }
                return
            }
            
            if httpResponse.statusCode == 200, let token = String(data: data, encoding: .utf8) {
                self.saveTokenAndNavigate(token: token)
            } else {
                DispatchQueue.main.async {
                    self.clearFieldsAndShowError(message: "Incorrect login")
                }
            }
        }.resume()
    }
    
    // MARK: - Save Token and Navigate
    private func saveTokenAndNavigate(token: String) {
        print("Token recibido: \(token)")
        UserDefaults.standard.set(token, forKey: "token")
        
        DispatchQueue.main.async {
            let heroesViewController = HeroesTableViewController()
            self.navigationController?.setViewControllers([heroesViewController], animated: true)
        }
    }
    
    // MARK: - Helpers
    private func clearFieldsAndShowError(message: String) {
        emailTextField.text = ""
        passwordTextField.text = ""
        showAlert(message: message)
    }
}
