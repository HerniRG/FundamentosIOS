//
//  TransformationDetailsViewController.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 23/9/24.
//

import UIKit

class TransformationDetailsViewController: UIViewController {

    // MARK: - Properties
    var transformation: Transformation?
    
    // MARK: - IBOutlets
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroDescriptionLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureHeroDetails()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UI Configuration
extension TransformationDetailsViewController {
    
    private func configureNavigationBar() {
        title = transformation?.name
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
        guard let hero = transformation else { return }
        heroDescriptionLabel.text = hero.description
        heroImage.layer.borderWidth = 2
        heroImage.layer.cornerRadius = 10
        heroImage.setImage(from: hero.photo)
    }
}
