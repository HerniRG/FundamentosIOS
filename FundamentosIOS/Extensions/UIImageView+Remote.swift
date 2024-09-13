//
//  UIImageView+Remote.swift
//  FundamentosIOS
//
//  Created by Hernán Rodríguez on 13/9/24.
//


import UIKit

extension UIImageView {
    func setImage(url: URL) {
        // Capturamos self para no crear dependencias circulares
        downloadWithURLSession(url: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
    
    // Este metodo obtiene una imagen a partir
    // de una URL. Utiliza URLSession para ello
    private func downloadWithURLSession(
        url: URL,
        completion: @escaping (UIImage?) -> Void
    ) {
        // No voy a manejar errores para simplificar el ejercicio
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
            guard let data, let image = UIImage(data: data) else {
                // No puedo desempaquetar data ni la imagen
                // llamo al completion con nil
                completion(nil)
                return
            }
            completion(image)
        }
        .resume()
    }
}
