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
        // Configurar la UI inicial, como agregar placeholders o estilos a los campos de texto
        emailTextField.placeholder = "Enter your email"
        passwordTextField.placeholder = "Enter your password"
    }
    
    // MARK: - Actions
    @IBAction func loginButton(_ sender: Any) {
        // Recogemos los valores de los TextFields
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Error: Email o contraseña vacíos")
            return
        }
        
        // Llamamos a la función de login
        login(email: email, password: password)
    }
    
    func login(email: String, password: String) {
        // URL del login
        let url = URL(string: "https://dragonball.keepcoding.education/api/auth/login")!
        
        // Crear la petición
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Crear el string de autenticación en formato "Basic base64(email:password)"
        let loginString = "\(email):\(password)"
        guard let loginData = loginString.data(using: .utf8) else {
            print("Error al codificar las credenciales")
            return
        }
        
        // Convertir las credenciales a Base64
        let base64LoginString = loginData.base64EncodedString()
        
        // Añadir el header "Authorization" con el valor "Basic base64(email:password)"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // Realizar la petición
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error en la petición: \(error?.localizedDescription ?? "Desconocido")")
                return
            }
            
            // Verificar si la respuesta es 200 OK
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Leer el token directamente como una cadena de texto
                if let token = String(data: data, encoding: .utf8) {
                    print("Token recibido: \(token)")
                    
                    // Guardar el token en UserDefaults para futuras peticiones
                    UserDefaults.standard.set(token, forKey: "token")
                    
                    // Redirigir a la pantalla de héroes en el hilo principal
                    DispatchQueue.main.async {
                        let heroesViewController = HeroesTableViewController()
                        self.show(heroesViewController, sender: self)
                    }
                } else {
                    print("Error: No se pudo convertir la respuesta en texto")
                }
            } else {
                // Si el login falla (401 No autorizado)
                print("Login fallido: \(response.debugDescription)")
                
                // Opcional: Imprimir el mensaje de error del servidor
                if  data == data, let errorMessage = String(data: data, encoding: .utf8) {
                    print("Mensaje de error: \(errorMessage)")
                }
            }
        }
        
        // Iniciar la tarea de la petición
        task.resume()
    }
    
    
    
}
