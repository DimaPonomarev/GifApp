//
//  MainScreenRouter.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 02.10.2023.
//

import UIKit

protocol MainScreenRouterProtocol: AnyObject {
    
    var presenter: MainScreenPresentationProtocol? {get set}
    func showShareAlertWith(_ dataToShare: ViewModel)
    func errorAlert(error: NetworkError)
}

class MainScreenRouter: MainScreenRouterProtocol {
    
    weak var presenter: MainScreenPresentationProtocol?
    
    func showShareAlertWith(_ dataToShare: ViewModel) {
        let activityViewController = UIActivityViewController(activityItems: [dataToShare.urlToImage], applicationActivities: nil)
        presenter?.viewController?.present(activityViewController, animated: true)
    }
    
    func errorAlert(error: NetworkError) {
        let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(cancel)
        presenter?.viewController?.present(alertController, animated: true)
    }
}
