//
//  MainScreenRouter.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 02.10.2023.
//

import UIKit

protocol MainScreenRouterProtocol: AnyObject {
    var presenter: MainScreenPresentationProtocol? {get set}
    
    func showShareAlertWith(_ dataToShare: MainScreenModels.ViewModel)
}

final class MainScreenRouter: MainScreenRouterProtocol {
    
    weak var presenter: MainScreenPresentationProtocol?
    
    func showShareAlertWith(_ dataToShare: MainScreenModels.ViewModel) {
        let activityViewController = UIActivityViewController(activityItems: [dataToShare.urlToImage], applicationActivities: nil)
        presenter?.viewController?.present(activityViewController, animated: true)
    }
}
