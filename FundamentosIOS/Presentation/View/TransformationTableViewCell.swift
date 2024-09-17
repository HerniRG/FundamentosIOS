//
//  TransformationTableViewCell.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 17/9/24.
//

import UIKit

class TransformationTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: TransformationTableViewCell.self)
    
    // MARK: - Outlets
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroTitleLabel: UILabel!
    @IBOutlet weak var heroDescriptionLabel: UILabel!
    @IBOutlet weak var viewCell: UIView!
    
    // MARK: - Configuration
    func configure(with transformation: Transformation) {
        // Configuramos las propiedades visuales de la celda
        viewCell.backgroundColor = UIColor.systemIndigo
        viewCell.layer.borderWidth = 3
        viewCell.layer.cornerRadius = 10
        heroImageView.layer.borderWidth = 2
        heroImageView.layer.cornerRadius = 10
        
        // Asignamos las propiedades del modelo Hero a los componentes de la celda
        heroTitleLabel.text = transformation.name
        heroDescriptionLabel.text = transformation.description
        heroImageView.setImage(from: transformation.photo)
    }
    
}
