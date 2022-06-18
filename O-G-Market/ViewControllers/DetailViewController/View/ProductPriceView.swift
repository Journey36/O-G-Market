//
//  ProductPriceView.swift
//  O-G-Market
//
//  Created by odongnamu on 2021/12/21.
//

import UIKit

class ProductPriceView: UIView {
    let mainPriceLabel = UILabel(textStyle: .title1)
    let subPriceLabel = UILabel(textStyle: .caption1, textColor: .gray)
    let stockLabel = UILabel(textStyle: .caption1, textColor: .gray)
    let buyButton = UIButton()
    private let priceStackView = UIStackView(axis: .vertical, alignment: .leading, spacing: 8)
    private let buyStackView = UIStackView(axis: .vertical, alignment: .leading)
    private let totalStackView = UIStackView(axis: .horizontal, alignment: .center)
    private let transparentBlankView = UIView(frame: CGRect.zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6

        configureBuyButton()
        addSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureBuyButton() {
        buyButton.setTitle("구매하기", for: .normal)
        buyButton.backgroundColor = UIColor(hex: "#736047")
        buyButton.layer.cornerRadius = 10
    }
}

extension ProductPriceView {
    private func addSubviews() {
        priceStackView.addArrangedSubview(subPriceLabel)
        priceStackView.addArrangedSubview(mainPriceLabel)
        buyStackView.addArrangedSubview(stockLabel)
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
            make.width.equalToSuperview().multipliedBy(0.9)
            make.bottom.equalToSuperview().offset(-30)
        }

        priceStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.6)
        }

        buyButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }

    func setUpComponentsData(product: Post) {
        if product.discountedPrice != 0 {
            subPriceLabel.text = composePrice(of: product)
            mainPriceLabel.text = composeBargainPrice(of: product)
            makeDiscountedPriceLabel()
        } else {
            subPriceLabel.text = "할인 없음"
            mainPriceLabel.text = composePrice(of: product)
        }

        stockLabel.text = "남은 수량: \(product.stock)"
        subPriceLabel.text? += " " + product.currency.rawValue
        mainPriceLabel.text? += " " + product.currency.rawValue

        if product.stock == 0 {
            buyButton.isEnabled = false
            buyButton.setTitle("품절", for: .normal)
            buyButton.backgroundColor = .systemGray3
        }
    }

    private func composePrice(of product: Post) -> String? {
        var priceText = String(product.price)
        guard let textStartIndex = priceText.firstIndex(of: ".") else { return nil }
        let textEndIndex = priceText.endIndex
        let bounds = textStartIndex..<textEndIndex

        if priceText.hasSuffix(".0") {
            priceText.removeSubrange(bounds)
        }

        return priceText
    }

    private func composeBargainPrice(of product: Post) -> String? {
        var bargainPriceText = String(product.bargainPrice)
        guard let textStartIndex = bargainPriceText.firstIndex(of: ".") else { return nil }
        let textEndIndex = bargainPriceText.endIndex
        let bounds = textStartIndex..<textEndIndex
        bargainPriceText.removeSubrange(bounds)
        return bargainPriceText
    }

    private func makeDiscountedPriceLabel() {
        let textAttributes = NSMutableAttributedString(string: subPriceLabel.text ?? "")
        let textRange = NSRange(location: 0, length: textAttributes.length)
        textAttributes.addAttributes([.font: UIFont.preferredFont(forTextStyle: .subheadline),
                                      .foregroundColor: UIColor(hex: "#cc0000"),
                                      .strikethroughStyle: 1], range: textRange)

        subPriceLabel.attributedText = textAttributes
    }
}
