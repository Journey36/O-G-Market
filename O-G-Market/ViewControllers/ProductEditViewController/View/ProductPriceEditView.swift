//
//  ProductPriceEditView.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/09.
//

import UIKit

class ProductPriceEditView: UIView {
    let currencyButton = UIButton()
    let priceTextField = UITextField()
    let discountButton = UIButton()
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(currencyButton)
        addSubview(priceTextField)
        addSubview(discountButton)
    }
    
    private func configureLayout() {

    }
    
}

class ProductDiscountView: UIView {
    
}
