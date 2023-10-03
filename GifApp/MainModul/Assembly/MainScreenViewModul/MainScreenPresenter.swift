//
//  MainScreenPresenter.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 02.10.2023.
//

import UIKit

protocol MainScreenPresentationProtocol: AnyObject{
    var viewController: MainScreenDisplayLogic? {get set}
    var router: MainScreenRouterProtocol? {get set}
    func responseFromInteractor(model: GIPHYModel)
    func responseFromInteractorWithPagging(model: GIPHYModel)
    func makeRequestToInteractorToProvideWeatherData(isPagging: Bool, in inputedTextInSearchBar: String)
    func getErrorFromInteractor(error: Error)
    func updateSearch(searchController: UISearchController)
}

class MainScreenPresenter: MainScreenPresentationProtocol {
    weak var viewController: MainScreenDisplayLogic?
    var router: MainScreenRouterProtocol?
    var interactor: MainScreenInteractorProtocol?

    func makeRequestToInteractorToProvideWeatherData(isPagging: Bool, in inputedTextInSearchBar: String) {
        if isPagging {
            viewController?.isLoading = true
        }
        interactor?.providingGifData(isPagging: isPagging, in: inputedTextInSearchBar)
    }
    
    func responseFromInteractor(model: GIPHYModel) {
        var arrayOfModels = [ModelToShowOnScreen]()

        for each in model.data {
            let eachURL = each.images.original.url
            let model = ModelToShowOnScreen(image: eachURL)
            arrayOfModels.append(model)
        }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.viewController?.passDataFromPresenterToViewController(model: arrayOfModels)
        }
    }
    
    func responseFromInteractorWithPagging(model: GIPHYModel) {
        var arrayOfModels = [ModelToShowOnScreen]()

        for each in model.data {
            let eachURL = each.images.original.url
            let model = ModelToShowOnScreen(image: eachURL)
            arrayOfModels.append(model)
        }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.viewController?.passDataFromPresenterToViewControllerWithPagging(model: arrayOfModels)
        }
    }
    
    func updateSearch(searchController: UISearchController) {
        guard var gifName = searchController.searchBar.text else { return }
        gifName = gifName.replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range: nil)

        if gifName.count > 3 {
            makeRequestToInteractorToProvideWeatherData(isPagging: false, in: gifName)
        }
    }
    
    func getErrorFromInteractor(error: Error) {
//        router.showError()
    }
}
