//
//  CustomTableViewCell.swift
//  GifApp
//
//  Created by Дмитрий Пономарев on 02.10.2023.
//

import UIKit
import SnapKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        String(describing: self)
    }
    
    //MARK: - UI properties
    
    private let imageView = UIImageView()
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        
    }
    
    // MARK: - Public Methods
    
    func configureView(_ model: MainScreenModels.ViewModel) {
        self.imageView.image = model.image
    }
}

//MARK: - Private methods

private extension CustomCollectionViewCell {
    
    //MARK: - Setup
    
    func setup() {
        addViews()
        makeConstraints()
    }
    
    //MARK: - addViews
    
    func addViews() {
        contentView.addSubview(imageView)
    }
    
    //MARK: - makeConstraints
    
    func makeConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
    }
}
