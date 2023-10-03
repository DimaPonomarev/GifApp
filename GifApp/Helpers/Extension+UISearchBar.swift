//
//  Extension+UISearchBar.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 02.10.2023.
//

import UIKit

extension UISearchBar {
    
    var textField: UITextField? {
        guard let text = self.value(forKey: "searchField") as? UITextField else {
            return nil
        }
        return text
    }
}
