//
//  HeroesTableViewCell.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 13/9/24.
//

import UIKit

class HeroesTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: HeroesTableViewCell.self)
    
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroTitleLabel: UILabel!
    @IBOutlet weak var heroDescriptionLabel: UILabel!
    @IBOutlet weak var viewCell: UIView!
    
    // MARK: - Configuration
    func configure(with hero: Hero) {
        // Configuramos las propiedades visuales de la celda
        viewCell.backgroundColor = UIColor.systemIndigo
        viewCell.layer.borderWidth = 3
        viewCell.layer.cornerRadius = 10
        heroImageView.layer.borderWidth = 2
        heroImageView.layer.cornerRadius = 10
        
        // Asignamos las propiedades del modelo Hero a los componentes de la celda
        heroTitleLabel.text = hero.name
        heroDescriptionLabel.text = hero.description
        heroImageView.setImage(url: hero.photo)
    }
    
}
