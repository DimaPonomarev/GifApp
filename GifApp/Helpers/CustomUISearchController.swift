//
//  CustomUISearchController.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 03.10.2023.
//

import UIKit

final class CustomSearchController: UISearchController, UISearchResultsUpdating {

    var closure: ((String) ->())?

    init() {
        super.init(searchResultsController: nil)
        setupSearchController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSearchController() {
        searchBar.searchTextField.backgroundColor = .white.withAlphaComponent(0.7)
        searchResultsUpdater = self
        searchBar.searchTextField.placeholder = "Enter text to search GIF"
    }
}

extension CustomSearchController {
    
    func updateSearchResults(for searchController: UISearchController) {
        closure?(searchController.searchBar.text ?? "")
    }
}
