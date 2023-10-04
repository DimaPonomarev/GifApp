//
//  CustomUISearchController.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 03.10.2023.
//

import UIKit

final class CustomSearchController: UISearchBar {
    
    //MARK: - init

    init(placeholderText: String) {
        super.init(frame: .zero)
        setupSearchController()
        placeholder = placeholderText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - closure
    
    var getTextClouser: ((String) ->())?
}

//MARK: - Private Methods

private extension CustomSearchController {
    
    func setupSearchController() {
        searchBarStyle = .default
        sizeToFit()
        backgroundImage = UIImage()
        backgroundColor = .white
        clipsToBounds = true
        delegate = self
    }
}

//MARK: - UISearchBarDelegate

extension CustomSearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getTextClouser?(searchText)
    }
}
