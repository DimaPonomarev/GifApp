//
//  ViewController.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 02.10.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let api = APIGIPHYRequest()
    let imageView = UIImageView(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.backgroundColor = .blue
        view.backgroundColor = .brown
//        makeGif()
    }
    
//    func makeGif() {
//        api.getGif(searchFilter: SearchFilter(word: "wow")) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .succes(let result):
//                    let model = result as? Modeling
//                    guard let model,
//                          let data = model.data.first,
////                          let url = URL(string: data.images.original.url) else { return }
////                    self.imageView.downloadGifImage(url: url)
////                    print(data)
//                case .failure(let error):
////                    print(error)
//                }
//            }
//        }
//    }
}

