//
//  HeroDetailsViewController.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 16/9/24.
//

import UIKit

class HeroDetailsViewController: UIViewController {
    
    // MARK: - Properties
    var hero: Hero?
    private var transformations: [Transformation] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var descriptionHeroLabel: UILabel!
    @IBOutlet weak var transformacionesButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHeroDetails()
        fetchTransformations()
    }
    
    // MARK: - Actions
    @IBAction func transformacionesButton(_ sender: Any) {
        let transformationTableViewController = TransformationTableViewController()
        transformationTableViewController.transformations = transformations
        navigationController?.pushViewController(transformationTableViewController, animated: true)
    }
    
}

// MARK: - UI Configuration
extension HeroDetailsViewController {
    
    private func configureNavigationBar() {
        title = hero?.name
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemIndigo
        appearance.shadowColor = UIColor.black
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func configureHeroDetails() {
        guard let hero = hero else { return }
        descriptionHeroLabel.text = hero.description
        heroImage.layer.borderWidth = 2
        heroImage.layer.cornerRadius = 10
        heroImage.setImage(from: hero.photo)
        transformacionesButton.isHidden = true
    }
}

// MARK: - Networking
extension HeroDetailsViewController {
    
    private func fetchTransformations() {
        guard let request = createTransformationRequest() else {
            print("No se pudo crear el request")
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error en la petición: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No se recibieron datos")
                return
            }
            
            do {
                let transformations = try JSONDecoder().decode([Transformation].self, from: data)
                
                DispatchQueue.main.async {
                    if !transformations.isEmpty {
                        self.transformations = transformations
                        self.transformacionesButton.isHidden = false
                    } else {
                        self.transformacionesButton.isHidden = true
                    }
                }
            } catch {
                print("Error al decodificar los datos: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // Request
    private func createTransformationRequest() -> URLRequest? {
        guard let hero = hero else {
            print("Hero no disponible")
            return nil
        }
        
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/heros/tranformations") else {
            print("Invalid URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token no disponible")
            return nil
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = ["id": hero.id]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        return request
    }
}
