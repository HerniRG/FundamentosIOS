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
   
    // MARK: - IBOutlets
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var descriptionHeroLabel: UILabel!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHeroDetails()
    }
    
    // MARK: - UI Configuration
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
    }
    
    // MARK: - Actions    
    @IBAction func transformacionesButton(_ sender: Any) {
    }
    
}
