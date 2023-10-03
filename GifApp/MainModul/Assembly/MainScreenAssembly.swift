//
//  MainScreenAssembly.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 02.10.2023.
//

import UIKit

final class MainScreenAssembly{
    func configurate(_ vc: MainScreenDisplayLogic) {
        let presenter = MainScreenPresenter()
        let router = MainScreenRouter()
        let interactor = MainScreenInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        vc.presenter = presenter
        presenter.viewController = vc
        presenter.router = router
        router.presenter = presenter
    }
}
