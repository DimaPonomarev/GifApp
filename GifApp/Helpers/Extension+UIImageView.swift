//
//  Extension+UIImageView.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 02.10.2023.
//

import UIKit


final class WebImageView: UIImageView {
    
    func downloadGifImage(imageUrl: String?) {
        guard let imageUrl, let url = URL(string: imageUrl) else {return}
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async { [weak self] in
                guard let self, let data else { return }
                if let image = UIImage().GIFMakerFromImageWith(data) {
                    self.image = image
                }
            }
        }
        dataTask.resume()
    }
}
