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
    @IBOutlet weak var transformacionesButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var transformacionesButtonBottomConstraint: NSLayoutConstraint!
    
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
        
        let favoriteImage = UIImage(systemName: hero?.favorite == true ? "star.fill" : "star")
        let favoriteButton = UIBarButtonItem(image: favoriteImage, style: .plain, target: self, action: #selector(toggleStarIcon))
        favoriteButton.tintColor = UIColor.yellow
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    private func configureHeroDetails() {
        guard let hero = hero else { return }
        descriptionHeroLabel.text = hero.description
        heroImage.layer.borderWidth = 2
        heroImage.layer.cornerRadius = 10
        heroImage.setImage(from: hero.photo)
        
        updateTransformationsButton(isVisible: false)
    }

    // Función que actualiza el botón de transformaciones
    private func updateTransformationsButton(isVisible: Bool) {
        transformacionesButton.isHidden = !isVisible
        transformacionesButtonHeightConstraint.constant = isVisible ? 50 : 0
        transformacionesButtonBottomConstraint.constant = isVisible ? 16 : 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func toggleStarIcon() {
        // Cambia el icono de la estrella entre "star.fill" y "star"
        let isFavorite = navigationItem.rightBarButtonItem?.image == UIImage(systemName: "star.fill")
        let newImage = UIImage(systemName: isFavorite ? "star" : "star.fill")
        navigationItem.rightBarButtonItem?.image = newImage
    }

}

// MARK: - Networking
extension HeroDetailsViewController {
    
    private func fetchTransformations() {
        guard let hero = hero else {
            print("Hero no disponible")
            return
        }
        
        NetworkModel.shared.fetchTransformations(heroId: hero.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transformations):
                    self?.transformations = transformations
                    self?.updateTransformationsButton(isVisible: !transformations.isEmpty)
                    
                case .failure:
                    print("Failed to fetch transformations")
                    self?.updateTransformationsButton(isVisible: false)
                }
            }
        }
    }
}
