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
    
    func getCountModel() -> Int
    func getModel(index: Int) -> MainScreenModels.ViewModel
    
    func textSearch(inputedText: String?)
    func firstLoadData(text: String)
    func loadAdditionalData()
}

class MainScreenPresenter: MainScreenPresentationProtocol {
    
    //    MARK: - VIPER Properties
    
    weak var viewController: MainScreenDisplayLogic?
    var router: MainScreenRouterProtocol?
    var interactor: MainScreenInteractorProtocol?
    
    //    MARK: - Data Variables
    
    private var searchWorkItem: DispatchWorkItem?
    private var isLoading = false
    private var inputedText: String = ""
    private var model: [MainScreenModels.ViewModel] = []
    
    //    MARK: - Delegate methodes
    
    func firstLoadData(text: String) {
        
        isLoading = true
        
        interactor?.providingGifData(isPagging: false, in: text) { [weak self] result in
            guard let self else { return }
            switch result {
            case .succes(let response):
                if let model = response as? MainScreenModels.GIPHYModel, !model.data.isEmpty {
                    self.createViewModel(model: model) {
                        self.isLoading = false
                        DispatchQueue.main.async { [weak self] in
                            guard let self else { return }
                            self.viewController?.updateView()
                        }
                    }
                }
            case.failure(let error):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.checkError(error: error)
                }
            }
        }
    }
    
    func textSearch(inputedText: String?) {
        interactor?.cancelAllRequests()
        searchWorkItem?.cancel()
        self.model = []
        self.viewController?.updateView()
        setupWorkItem(workItem: &searchWorkItem, deadline: 2) { [weak self] in
            guard let self else { return }
            self.inputedText = inputedText ?? ""
            self.firstLoadData(text: self.inputedText)
        }
    }
    
    func loadAdditionalData() {
        guard !isLoading else { return }
        isLoading = true
        interactor?.providingGifData(isPagging: true, in: inputedText) { [weak self] result in
            guard let self else { return }
            switch result {
            case .succes(let response):
                if let model = response as? MainScreenModels.GIPHYModel, !model.data.isEmpty {
                    self.createViewModel(model: model) {
                        self.isLoading = false
                        DispatchQueue.main.async { [weak self] in
                            guard let self else { return }
                            self.viewController?.updateView()
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.checkError(error: error)
                }
            }
        }
    }
    
    //    MARK: - get ViewModel
    
    func getCountModel() -> Int {
        model.count
    }
    
    func getModel(index: Int) -> MainScreenModels.ViewModel {
        model[index]
    }
}

private extension MainScreenPresenter {
    
    func setupWorkItem(workItem: inout DispatchWorkItem?, deadline: Double, with action: @escaping ()->() ) {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        guard let workItem = workItem else { return }
        DispatchQueue.global().asyncAfter(deadline: .now() + deadline, execute: workItem)
    }
    
    func createViewModel(model: MainScreenModels.GIPHYModel?, handler: @escaping () -> Void) {
        guard let model else { return }
        for each in model.data {
            let eachURL = each.images.original.url
            interactor?.downloadGifImage(imageUrl: eachURL) { [weak self] image in
                guard let self else { return }
                self.model.append(MainScreenModels.ViewModel(image: image, urlToImage: eachURL))
                handler()
            }
        }
    }
    
    func checkError(error: NetworkError) {
        if case .canceledResponse = error { return }
        self.viewController?.showErrorAlert(error: error)
    }
}

