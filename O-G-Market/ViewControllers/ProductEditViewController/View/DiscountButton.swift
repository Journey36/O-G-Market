//
//  DiscountButton.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/10.
//

import UIKit

class DiscountButton: UIButton {
    let checkBoxImage = UIImage(systemName: "circle")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("할인하기", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
