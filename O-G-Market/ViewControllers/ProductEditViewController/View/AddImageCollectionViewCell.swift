//
//  AddImageCell.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/22.
//

import Foundation
import UIKit

class AddImageCollectionViewCell: UICollectionViewCell {
    static let id = "AddImageCell"
    let cellColor = UIColor.gray
    let stackView = UIStackView(axis: .vertical, alignment: .center, spacing: 8, distribution: .fill)
    let imageView = UIImageView()
    let numberOfImageLabel = UILabel(textStyle: .callout, textColor: .gray)

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        configureLayout()
        configureStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(numberOfImageLabel)
    }

    private func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
    }

    private func configureStyle() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 3
        self.layer.borderColor = cellColor.cgColor

        imageView.image = UIImage(systemName: "camera.fill")
        imageView.tintColor = cellColor
    }
}
