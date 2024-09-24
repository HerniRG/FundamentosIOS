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
        configureNavigationBar(title: transformation?.name, backgroundColor: UIColor.systemIndigo)
        configureHeroDetails()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UI Configuration
extension TransformationDetailsViewController {
    
    private func configureHeroDetails() {
        guard let hero = transformation else { return }
        heroDescriptionLabel.text = hero.description
        heroImage.layer.borderWidth = 2
        heroImage.layer.cornerRadius = 10
        heroImage.setImage(from: hero.photo)
    }
}
