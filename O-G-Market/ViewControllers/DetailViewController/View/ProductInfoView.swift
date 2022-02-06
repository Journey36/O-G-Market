//
//  ProductInfoView.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/03.
//

import UIKit

class ProductInfoView: UIView {
    let titleLabel = UILabel(textStyle: .largeTitle)
    let registrationDateLabel = UILabel(textStyle: .body, textColor: .darkGray)
    let descriptionLabel = UILabel(textStyle: .body)
    private let stackView = UIStackView(axis: .vertical, alignment: .leading, spacing: 8, distribution: .equalSpacing)
    private let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        configureLayout()
        descriptionLabel.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        registrationDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(registrationDateLabel.snp.bottom).offset(15)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        }
    }
    
    private func addSubviews() {
        containerView.addSubview(titleLabel)
        containerView.addSubview(registrationDateLabel)
        containerView.addSubview(descriptionLabel)
        addSubview(containerView)
    }
    
    func setUpComponentsData(product: ProductDetails) {
        titleLabel.text = product.name
        descriptionLabel.text = product.description
        registrationDateLabel.text = product.createdAt
    }
}
