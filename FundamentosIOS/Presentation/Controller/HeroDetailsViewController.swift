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
    }
    
    private func configureHeroDetails() {
        guard let hero = hero else { return }
        descriptionHeroLabel.text = hero.description
        heroImage.layer.borderWidth = 2
        heroImage.layer.cornerRadius = 10
        heroImage.setImage(from: hero.photo)
        transformacionesButton.isHidden = true
        transformacionesButtonHeightConstraint.constant = 0
        transformacionesButtonBottomConstraint.constant = 0
    }
}

// MARK: - Networking
extension HeroDetailsViewController {
    
    private func fetchTransformations() {
        guard let hero = hero else {
            print("Hero no disponible")
            return
        }
        
        NetworkModelTransformations.shared.fetchTransformations(heroId: hero.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transformations):
                    if !transformations.isEmpty {
                        self?.transformations = transformations
                        self?.transformacionesButton.isHidden = false
                        self?.transformacionesButtonHeightConstraint.constant = 50
                        self?.transformacionesButtonBottomConstraint.constant = 16
                    } else {
                        self?.transformacionesButton.isHidden = true
                        self?.transformacionesButtonHeightConstraint.constant = 0
                        self?.transformacionesButtonBottomConstraint.constant = 0
                    }
                    UIView.animate(withDuration: 0.3) {
                        self?.view.layoutIfNeeded()
                    }
                case .failure(let error):
                    print("Error al obtener las transformaciones: \(error)")
                }
            }
        }
    }
}
