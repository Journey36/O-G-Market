//
//  ProductPriceView.swift
//  O-G-Market
//
//  Created by odongnamu on 2021/12/21.
//

import UIKit

class ProductPriceView: UIView {
    let priceLabel = UILabel(textStyle: .title1)
    let originalPriceLabel = UILabel(textStyle: .callout, textColor: .gray)
    let remainingCountLabel = UILabel(textStyle: .callout, textColor: .gray)
    let buyButton = UIButton()
    let priceStackView = UIStackView(axis: .vertical, alignment: .leading, sapcing: 8)
    let buyStackView = UIStackView(axis: .vertical, alignment: .leading)
    let totalStackView = UIStackView(axis: .horizontal, alignment: .center)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureBuyButton()
        addSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureBuyButton() {
        buyButton.titleLabel?.text = "Buy"
        buyButton.backgroundColor = .green
        buyButton.layer.cornerRadius = 10
    }
}

extension ProductPriceView {
    private func addSubviews() {
        priceStackView.addSubview(originalPriceLabel)
        priceStackView.addSubview(priceLabel)
        buyStackView.addSubview(remainingCountLabel)
        buyStackView.addSubview(buyButton)
        totalStackView.addSubview(priceStackView)
        totalStackView.addSubview(buyStackView)
    }
    
    private func configureLayout() {
        
    }
}
