//
//  MainScreenModels.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 02.10.2023.
//

import UIKit

struct GIPHYModel: Decodable {
    let data: [Images]
    
    struct Images: Decodable {
        var images: Originals
        
        struct Originals: Decodable {
            var original: URLOfGif
            
            struct URLOfGif: Decodable {
                var url: String
            }
        }
    }
}

struct ViewModel {
    var image: UIImage
    var urlToImage: String
}
