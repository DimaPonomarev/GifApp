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
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    //MARK: - UI properties
    
    let imageView = WebImageView()
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Public Methods
    
    func configureView(_ model: ModelToShowOnScreen) {
        self.imageView.downloadGifImage(imageUrl: model.image)
    }
}

//MARK: - Private methods

private extension CustomCollectionViewCell {
    
    //MARK: - Setup
    
    func setup() {
        addViews()
        makeConstraints()
        setupViews()
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
    
    //MARK: - setupViews
    
    func setupViews() {
        
    }
}
