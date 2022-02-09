//
//  ProductImageCell.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/22.
//

import Foundation
import UIKit
import SwiftUI

class AddedImageCollectionViewCell: UICollectionViewCell {
    static let id = "AddedImageCollectionViewCell"
    let imageView = UIImageView()
    let deleteButton = UIButton()
    var deleteDelegate: DeleteDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        configureLayout()
        configureStyle()
        configureButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addSubviews() {
        self.addSubview(imageView)
        self.addSubview(deleteButton)
    }

    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        deleteButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.trailing)
            make.centerY.equalTo(self.snp.top)
        }
    }

    private func configureStyle() {
        self.layer.cornerRadius = 5
        deleteButton.tintColor = .gray
    }

    private func configureButton() {
        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteSelf), for: .touchUpInside)
    }


    @objc private func deleteSelf() {
        guard let image = imageView.image else { return }
        deleteDelegate?.deleteCell(image: image)
    }
}
