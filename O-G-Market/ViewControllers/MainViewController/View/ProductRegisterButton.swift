//
//  ProductRegisterButton.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/29.
//

import UIKit

class ProductRegisterButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureButton() {
        let buttonImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .bold))

        self.setImage(buttonImage, for: .normal)
        self.backgroundColor = .systemIndigo
        self.tintColor = .white
        self.layer.cornerRadius = 35
    }
}
