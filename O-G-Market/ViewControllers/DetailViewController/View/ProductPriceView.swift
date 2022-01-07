//
//  ProductPriceView.swift
//  O-G-Market
//
//  Created by odongnamu on 2021/12/21.
//

import UIKit

class ProductPriceView: UIView {
    let priceLabel = UILabel(textStyle: .title1)
    let originalPriceLabel = UILabel(textStyle: .caption1, textColor: .gray)
    let remainingCountLabel = UILabel(textStyle: .caption1, textColor: .gray)
    let buyButton = UIButton()
    let priceStackView = UIStackView(axis: .vertical, alignment: .leading, sapcing: 8)
    let buyStackView = UIStackView(axis: .vertical, alignment: .leading)
    let totalStackView = UIStackView(axis: .horizontal, alignment: .center)
    let transparentBlankView = UIView(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6
        
        priceLabel.text = "10000원"
        originalPriceLabel.text = "20000원"
        remainingCountLabel.text = "남은 수량: 1개"
        configureBuyButton()
        addSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureBuyButton() {
        buyButton.setTitle("구매하기", for: .normal)
        buyButton.backgroundColor = .systemGray3
        buyButton.layer.cornerRadius = 10
    }
}

extension ProductPriceView {
    private func addSubviews() {
        priceStackView.addArrangedSubview(originalPriceLabel)
        priceStackView.addArrangedSubview(priceLabel)
        buyStackView.addArrangedSubview(remainingCountLabel)
        buyStackView.addArrangedSubview(buyButton)
        totalStackView.addArrangedSubview(priceStackView)
        totalStackView.addArrangedSubview(buyStackView)
        
        addSubview(totalStackView)
        addSubview(transparentBlankView)
    }
    
    private func configureLayout() {
        totalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        priceStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        
        buyButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
    }
}
