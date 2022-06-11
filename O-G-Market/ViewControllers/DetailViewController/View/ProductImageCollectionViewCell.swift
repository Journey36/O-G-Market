//
//  ProductInfoImageCollectionViewCell.swift
//  O-G-Market
//
//  Created by odongnamu on 2021/12/27.
//

import UIKit

class ProductImageCollectionViewCell: UICollectionViewCell {
    static let id = String(describing: ProductImageCollectionViewCell.self)
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
