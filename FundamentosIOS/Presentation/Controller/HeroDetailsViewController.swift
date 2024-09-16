//
//  HeroDetailsViewController.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 16/9/24.
//

import UIKit

class HeroDetailsViewController: UIViewController {
    
    var hero: Hero?
   
    // MARK: - IBOutlets
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var descriptionHeroLabel: UILabel!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureUITextAndImage()
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
    
    private func configureUITextAndImage() {
        heroImage.layer.borderWidth = 2
        heroImage.layer.cornerRadius = 10
        descriptionHeroLabel.text = hero?.description
        heroImage.setImage(url: hero!.photo)
    }
    
    // MARK: - Actions    
    @IBAction func transformacionesButton(_ sender: Any) {
    }
    
}
