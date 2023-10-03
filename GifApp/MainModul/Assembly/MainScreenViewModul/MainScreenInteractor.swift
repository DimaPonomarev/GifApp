//
//  MainScreenInteractor.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 02.10.2023.
//

import UIKit


protocol MainScreenInteractorProtocol {
    func providingGifData(isPagging: Bool, in inputedTextInSearchBar: String)
}

final class MainScreenInteractor: MainScreenInteractorProtocol {
    
    //    MARK: - Properties
    
    var presenter: MainScreenPresentationProtocol?
    private let GIPHYManagerNetwork = APIGIPHYRequest()
    
    //MARK: - make request to WeatherManagerNetwork to get data and provide it to Presenter
    
    func providingGifData(isPagging: Bool, in inputedTextInSearchBar: String) {
        GIPHYManagerNetwork.getGif(isPagging: isPagging, searchFilter: SearchFilter(word: inputedTextInSearchBar)) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .succes(let result):
                    if !isPagging {
                        self.presenter?.responseFromInteractor(model: result as! GIPHYModel)
                    } else {
                        self.presenter?.responseFromInteractorWithPagging(model: result as! GIPHYModel)
                    }
                case .failure(let error):
                    self.presenter?.getErrorFromInteractor(error: error as NSError)
                }
            }
        }
    }
}
