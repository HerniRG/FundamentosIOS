//
//  HeroesTableViewCell.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 13/9/24.
//

import UIKit

class HeroesTableViewCell: UITableViewCell {
    
// MARK: - Static Properties
    static let identifier = String(describing: HeroesTableViewCell.self)
    
// MARK: - IBOutlets
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroTitleLabel: UILabel!
    @IBOutlet weak var heroDescriptionLabel: UILabel!
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
// MARK: - Cell Configuration
    func configure(with hero: Hero) {
        
        viewCell.backgroundColor = UIColor.systemIndigo
        viewCell.layer.borderWidth = 3
        viewCell.layer.cornerRadius = 10
        
        heroImageView.layer.borderWidth = 2
        heroImageView.layer.cornerRadius = 10
        heroImageView.setImage(from: hero.photo)
        
        favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
        favoriteImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        favoriteImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        favoriteImageView.image = UIImage(systemName: hero.favorite ? "star.fill" : "star")
        favoriteImageView.tintColor = .yellow
        
        heroTitleLabel.text = hero.name
        heroTitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        heroDescriptionLabel.text = hero.description
        
    }
    
}
