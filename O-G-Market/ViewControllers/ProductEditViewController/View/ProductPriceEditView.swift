//
//  ProductPriceEditView.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/09.
//

import UIKit

class ProductPriceEditView: UIView {
    let currencyPickerTextField = UITextField()
    let priceTextField = UITextField()
    let discountButton = UIButton()
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureLayout()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        stackView.addArrangedSubview(currencyPickerTextField)
        stackView.addArrangedSubview(priceTextField)
        stackView.addArrangedSubview(discountButton)
        addSubview(stackView)
    }
    
    private func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        }
        
        currencyPickerTextField.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}

class ProductDiscountView: UIView {
    
}
