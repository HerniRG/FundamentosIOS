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
    
    
    // MARK: - Actions
    @IBAction func loginButton(_ sender: Any) {
        // Obtener los textos de los campos
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        var errorMessage: [String] = []
        
        if email.isEmpty {
            errorMessage.append("Email is empty")
        }
        if password.isEmpty {
            errorMessage.append("Password is empty")
        }
        if !errorMessage.isEmpty {
            showAlert(message: errorMessage.joined(separator: "\n"))
            return
        }
        
        login(email: email, password: password)
    }
    
    func login(email: String, password: String) {
        let url = URL(string: "https://dragonball.keepcoding.education/api/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let loginString = "\(email):\(password)"
        guard let loginData = loginString.data(using: .utf8) else {
            print("Error al codificar las credenciales")
            return
        }
        
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error en la petición: \(error?.localizedDescription ?? "Desconocido")")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let token = String(data: data, encoding: .utf8) {
                    print("Token recibido: \(token)")
                    UserDefaults.standard.set(token, forKey: "token")
                    
                    DispatchQueue.main.async {
                        let heroesViewController = HeroesTableViewController()
                        self.navigationController?.setViewControllers([heroesViewController], animated: true)
                    }
                } else {
                    print("Error: No se pudo convertir la respuesta en texto")
                }
            } else {
                DispatchQueue.main.async {
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.showAlert(message: "Incorrect login")
                }
            }
        }
        
        task.resume()
    }
}
