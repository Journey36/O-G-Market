//
//  ListItem.swift
//  O-G-Market
//
//  Created by 재현 on 2021/12/25.
//

import UIKit

class ListItem: UICollectionViewListCell {
	static let identifier = String(describing: ListItem.self)
	let productImageView: UIImageView = {
		let productImageView = UIImageView()
		productImageView.contentMode = .scaleAspectFit
		return productImageView
	}()

	let labelStackView: UIStackView = {
		let labelStackView = UIStackView()
		labelStackView.alignment = .leading
		labelStackView.axis = .horizontal
		labelStackView.spacing = 5
		labelStackView.distribution = .fillProportionally
		return labelStackView
	}()

	let productNameLabel: UILabel = {
		let productNameLabel = UILabel()
		productNameLabel.font = .preferredFont(forTextStyle: .headline)
		return productNameLabel
	}()

	let productDiscountedPriceLabel: UILabel = {
		let productDiscountedPriceLabel = UILabel()
		let textAttributes = NSMutableAttributedString(string: productDiscountedPriceLabel.text ?? "nil")
		let textRange = NSRange(location: 0, length: textAttributes.length)
		textAttributes.addAttributes([.font: UIFont.preferredFont(forTextStyle: .subheadline), .foregroundColor: UIColor.systemRed, .strikethroughStyle: 1], range: textRange)
		productDiscountedPriceLabel.attributedText = textAttributes
		return productDiscountedPriceLabel
	}()

	let productPriceLabel: UILabel = {
		let productPriceLabel = UILabel()
		productPriceLabel.font = .preferredFont(forTextStyle: .subheadline)
		productPriceLabel.textColor = .systemGray
		return productPriceLabel
	}()

	let productStockLabel: UILabel = {
		let productStockLabel = UILabel()
		let textAttributes = NSMutableAttributedString(string: productStockLabel.text ?? "nil")
		let textRange = NSRange(location: 0, length: textAttributes.length)
		textAttributes.addAttributes([.font: UIFont.preferredFont(forTextStyle: .subheadline), .foregroundColor: UIColor.systemYellow], range: textRange)
		productStockLabel.attributedText = textAttributes
		return productStockLabel
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureHierachy()
		configureConstraints()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configureHierachy()
		configureConstraints()
	}

	private func configureHierachy() {
		contentView.addSubview(productImageView)
		contentView.addSubview(labelStackView)
		contentView.addSubview(productNameLabel)
		contentView.addSubview(productStockLabel)

		labelStackView.addArrangedSubview(productDiscountedPriceLabel)
		labelStackView.addArrangedSubview(productPriceLabel)
	}

	private func configureConstraints() {
		productImageView.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.leading.equalToSuperview().offset(20)
			make.trailing.equalTo(productNameLabel.snp.leading).offset(-10)
			make.width.height.equalTo(50)
		}

		productNameLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(10)
			make.trailing.lessThanOrEqualTo(productStockLabel.snp.leading).offset(10)
			make.bottom.equalTo(contentView.snp.centerY)
		}

		labelStackView.snp.makeConstraints { make in
			make.top.equalTo(contentView.snp.centerY)
			make.leading.equalTo(productNameLabel)
			make.trailing.equalTo(productNameLabel)
			make.bottom.equalToSuperview().offset(-20)
		}

		productStockLabel.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.top.bottom.equalTo(productImageView)
			make.trailing.equalToSuperview().offset(-20)
		}
	}
}
