//
//  MainScreenInteractor.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 02.10.2023.
//

import UIKit

protocol MainScreenInteractorProtocol {
    func providingGifData(isPagging: Bool, in inputedTextInSearchBar: String, handler: @escaping ((Result<Any, NetworkError>) -> Void))
    func downloadGifImage(imageUrl: String?, handler: @escaping ((UIImage)-> Void))
    func cancelAllRequests()
}

final class MainScreenInteractor: MainScreenInteractorProtocol {
    
    //    MARK: - Properties
    
    weak var presenter: MainScreenPresentationProtocol?
    private let GIPHYManagerNetwork = APIGIPHYRequest()
    
    //TODO: - make request to WeatherManagerNetwork to get data and provide it to Presenter
    
    func providingGifData(isPagging: Bool, in inputedTextInSearchBar: String, handler: @escaping ((Result<Any, NetworkError>) -> Void)) {
        GIPHYManagerNetwork.getGIF(isPagging: isPagging, searchFilter: SearchFilter(word: inputedTextInSearchBar), complition: handler)
    }
    
    func downloadGifImage(imageUrl: String?, handler: @escaping ((UIImage)-> Void)) {

        guard let imageUrl, let url = URL(string: imageUrl) else {return}
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data else { return }
            DispatchQueue.global(qos: .userInteractive).async {
                if let GIFImage = UIImage().GIFMakerFromImageWith(data) {
                    handler(GIFImage)
                }
            }
        }
        dataTask.resume()
    }
    
    func cancelAllRequests() {
        DispatchQueue.global().sync {
            URLSession.shared.getAllTasks { allTasks in
                allTasks.filter { $0.state == .running }.forEach{ $0.cancel() }
            }
        }
    }
}



