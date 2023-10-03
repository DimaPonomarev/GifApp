//
//  MainScreenRouter.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 02.10.2023.
//

import UIKit

protocol MainScreenRouterProtocol: AnyObject {
    var presenter: MainScreenPresentationProtocol? {get set}
    func showAlert(dataToShare: String)
}

class MainScreenRouter: MainScreenRouterProtocol {
    weak var presenter: MainScreenPresentationProtocol?
    
    func showAlert(dataToShare: String) {

        let alertController = UIAlertController(title: "Поделиться", message: "Выберите способ", preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Поделиться", style: .default) { [weak self]
            action in
            guard let self else { return }
            let activityViewController = UIActivityViewController(activityItems: [dataToShare], applicationActivities: nil)
            self.presenter?.viewController?.present(activityViewController, animated: true)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(shareAction)
        alertController.addAction(cancel)
        
        self.presenter?.viewController?.present(alertController, animated: true)
        
    }
}
