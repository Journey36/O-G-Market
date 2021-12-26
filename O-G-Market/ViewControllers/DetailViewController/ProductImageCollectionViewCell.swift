//
//  ProductInfoImageCollectionViewCell.swift
//  O-G-Market
//
//  Created by odongnamu on 2021/12/27.
//

import UIKit

class ProductImageCollectionViewCell: UICollectionViewCell {
    static let id = "ProductInfoImageCollectionViewCell"
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        
        // 임시코드
        imageView.image = UIImage(systemName: "pencil")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: ProductImageCollectionViewCell Layout
extension ProductImageCollectionViewCell {
    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
