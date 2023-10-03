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
    func getModel(index: Int) -> ViewModel
    func firstLoadData(text: String)
    func loadAdditionalData()
    func requestFor(inputedText: String?)
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
    private var model: [ViewModel] = []
    
    //    MARK: - Delegate methodes
    
    func firstLoadData(text: String) {
        isLoading = true
        interactor?.providingGifData(isPagging: false, in: text) { [weak self] result in
            guard let self else { return }
            switch result {
            case .succes(let response):
                if let model = response as? GIPHYModel, !model.data.isEmpty {
                    self.createViewModel(model: model) {
                        self.isLoading = false
                        DispatchQueue.main.async { [weak self] in
                            guard let self else { return }
                            self.viewController?.updateView()
                        }
                    }
                }
            case.failure(let error):
                self.viewController?.showErrorAlert(error: error)
            }
        }
    }
    
    func requestFor(inputedText: String?) {
        interactor?.cancelAllRequests()
        searchWorkItem?.cancel()
        setupWorkItem(workItem: &searchWorkItem, deadline: 1) { [weak self] in
            guard let self else { return }
            self.model = []
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
                if let model = response as? GIPHYModel, !model.data.isEmpty {
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
                    guard let self else { return }
                    switch error {
                    case .canceledResponse: break
                    default: self.viewController?.showErrorAlert(error: error)
                    }
                }
            }
        }
    }
    
    //    MARK: - get ViewModel
    
    func getCountModel() -> Int {
        model.count
    }
    
    func getModel(index: Int) -> ViewModel {
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
    
    func createViewModel(model: GIPHYModel?, handler: @escaping () -> Void) {
        guard let model else { return }
        for each in model.data {
            let eachURL = each.images.original.url
            interactor?.downloadGifImage(imageUrl: eachURL) { [weak self] image in
                guard let self else { return }
                self.model.append(ViewModel(image: image, urlToImage: eachURL))
                handler()
            }
        }
    }
}
