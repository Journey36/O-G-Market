//

import UIKit
import SnapKit

class CarouselItem: UICollectionViewCell {
	static let identifier = String(describing: CarouselItem.self)
	let productImageView: UIImageView = {
		let productImageView = UIImageView()
		productImageView.contentMode = .scaleAspectFit
		return productImageView
	}()

	let labelStackView: UIStackView = {
		let labelStackView = UIStackView()
		labelStackView.alignment = .center
		labelStackView.axis = .vertical
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
		let priceLabel = NSMutableAttributedString(string: productDiscountedPriceLabel.text ?? "nil")
		let textRange = NSRange(location: 0, length: priceLabel.length)
		priceLabel.addAttributes([.font: UIFont.preferredFont(forTextStyle: .subheadline),
                                  .foregroundColor: UIColor.systemRed,
                                  .strikethroughStyle: 1], range: textRange)
		productDiscountedPriceLabel.attributedText = priceLabel
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
		productStockLabel.font = .preferredFont(forTextStyle: .subheadline)
		productStockLabel.textColor = .systemGray
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

		labelStackView.addArrangedSubview(productNameLabel)
		labelStackView.addArrangedSubview(productDiscountedPriceLabel)
		labelStackView.addArrangedSubview(productPriceLabel)
		labelStackView.addArrangedSubview(productStockLabel)
	}

	private func configureConstraints() {
		productImageView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalToSuperview().offset(10)
			make.leading.equalToSuperview().offset(15)
			make.trailing.equalToSuperview().offset(-15)
		}

		labelStackView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(productImageView.snp.bottom).offset(10)
			make.leading.equalToSuperview().offset(15)
			make.trailing.bottom.equalToSuperview().offset(-15)
		}
	}
}
