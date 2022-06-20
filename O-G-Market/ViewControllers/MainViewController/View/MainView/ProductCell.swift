//
//  ListItem.swift
//  O-G-Market
//
//  Created by 재현 on 2021/12/25.
//

import UIKit
import Alamofire

class ProductCell: UICollectionViewListCell {
	static let identifier = String(describing: ProductCell.self)

    var productID: Int?

    let postThumbnailImageView: UIImageView = {
		let postThumbnailImageView = UIImageView()
		postThumbnailImageView.contentMode = .scaleAspectFit
		return postThumbnailImageView
	}()

    let postTitleLabel: UILabel = {
        let postTitleLabel = UILabel()
        postTitleLabel.font = .preferredFont(forTextStyle: .headline)
        postTitleLabel.numberOfLines = 2
        return postTitleLabel
    }()
    let priceLabelStackView: UIStackView = {
        let priceLabelStackView = UIStackView()
        priceLabelStackView.axis = .horizontal
        priceLabelStackView.spacing = 5
        priceLabelStackView.distribution = .fillEqually
        return priceLabelStackView
    }()
    let productPriceLabel: UILabel = {
        let productPriceLabel = UILabel()
        productPriceLabel.font = .preferredFont(forTextStyle: .body)
        productPriceLabel.textColor = .systemGray
        return productPriceLabel
    }()
    let productBargainPriceLabel: UILabel = {
        let productBargainPriceLabel = UILabel()
        productBargainPriceLabel.font = .preferredFont(forTextStyle: .body)
        return productBargainPriceLabel
    }()

    let productStockLabel: UILabel = {
		let productStockLabel = UILabel()
        productStockLabel.font = .preferredFont(forTextStyle: .body)
        productStockLabel.numberOfLines = 0
		return productStockLabel
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		arrangeViews()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		arrangeViews()
	}

    override func prepareForReuse() {
        postThumbnailImageView.image = nil
        productPriceLabel.text = nil
        productBargainPriceLabel.text = nil
        productStockLabel.text = nil
        super.prepareForReuse()
    }

	private func arrangeViews() {
		contentView.addSubview(postThumbnailImageView)
		contentView.addSubview(priceLabelStackView)
		contentView.addSubview(postTitleLabel)
		contentView.addSubview(productStockLabel)

        priceLabelStackView.addArrangedSubview(productPriceLabel)
        priceLabelStackView.addArrangedSubview(productBargainPriceLabel)

        postThumbnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10).priority(.low)
            make.bottom.equalToSuperview().offset(-10).priority(.low)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(postTitleLabel.snp.leading).offset(-10)
            make.size.equalTo(90)
        }

        postTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(postThumbnailImageView)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(contentView.snp.centerY)
        }

        priceLabelStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.centerY)
            make.leading.equalTo(postThumbnailImageView.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualToSuperview().offset(-10)
            make.bottom.lessThanOrEqualTo(productStockLabel.snp.top)
        }

        productStockLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(postThumbnailImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(postThumbnailImageView)
        }
	}

    func composeCell(_ cell: ProductCell, with data: Post) {
        composeID(of: cell, from: data)
        composeImage(of: cell, from: data)
        composeTitle(of: cell, from: data)
        composePrice(of: cell, from: data)
        composeBargainPrice(of: cell, from: data)
        composeStock(of: cell, from: data)
    }
}

extension ProductCell {
    private func composeID(of cell: ProductCell, from data: Post) {
        cell.productID = data.id
    }

    private func composeImage(of cell: ProductCell, from data: Post) {
        DispatchQueue.global().async {
            guard let imageURL = URL(string: data.thumbnail), let imageData = try? Data(contentsOf: imageURL),
                  let image = UIImage(data: imageData) else { return }

            DispatchQueue.main.async {
                cell.postThumbnailImageView.image = image
            }
        }
    }

    private func composeTitle(of cell: ProductCell, from data: Post) {
        cell.postTitleLabel.text = data.name
    }

    private func composePrice(of cell: ProductCell, from data: Post) {
        let priceTextAttributes = NSMutableAttributedString(string: String(describing: data.price))
        let priceTextRange = NSRange(location: 0, length: priceTextAttributes.length)
        if data.discountedPrice != 0 {
            priceTextAttributes.addAttributes([.foregroundColor: UIColor.systemRed,
                                               .strikethroughStyle: 1,
                                               .strikethroughColor: UIColor.systemRed],
                                              range: priceTextRange)
            cell.productPriceLabel.attributedText = priceTextAttributes
            cell.priceLabelStackView.addArrangedSubview(cell.productBargainPriceLabel)
            if data.price - floor(data.price) >= 0 {
                switch data.currency {
                case .KRW:
                    cell.productPriceLabel.text = data.currency.rawValue + " " + String(describing: Int(data.price))
                case .USD:
                    cell.productPriceLabel.text = data.currency.rawValue + " " + String(describing: Int(data.price))
                }
            } else {
                switch data.currency {
                case .KRW:
                    cell.productPriceLabel.text = data.currency.rawValue + " " + String(describing: data.price)
                case .USD:
                    cell.productPriceLabel.text = data.currency.rawValue + " " + String(describing: data.price)
                }
            }
        } else {
            cell.priceLabelStackView.removeArrangedSubview(cell.productBargainPriceLabel)
        }
    }

    private func composeBargainPrice(of cell: ProductCell, from data: Post) {
        if data.bargainPrice - floor(data.bargainPrice) >= 0 {
            switch data.currency {
            case .KRW:
                cell.productBargainPriceLabel.text = data.currency.rawValue + " " + String(describing: Int(data.bargainPrice))
            case .USD:
                cell.productBargainPriceLabel.text = data.currency.rawValue + " " + String(describing: Int(data.bargainPrice))
            }
        } else {
            switch data.currency {
            case .KRW:
                cell.productBargainPriceLabel.text = data.currency.rawValue + " " + String(describing: data.bargainPrice)
            case .USD:
                cell.productBargainPriceLabel.text = data.currency.rawValue + " " + String(describing: data.bargainPrice)
            }
        }
    }

    private func composeStock(of cell: ProductCell, from data: Post) {
        let textAttributes = NSMutableAttributedString(string: String(describing: data.stock))
        let textRange = NSRange(location: 0, length: textAttributes.length)
        if data.stock == 0 {
            textAttributes.addAttributes([.foregroundColor: UIColor.systemYellow], range: textRange)
            cell.productStockLabel.attributedText = textAttributes
            cell.productStockLabel.text = "품절"
        } else {
            textAttributes.addAttributes([.foregroundColor: UIColor.systemGray4], range: textRange)
            cell.productStockLabel.attributedText = textAttributes
            cell.productStockLabel.text = "\(data.stock)개"
        }
    }
}
