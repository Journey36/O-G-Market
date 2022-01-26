//
//  UITextField+.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/26.
//

import UIKit

extension UITextField {
    convenience init(placeholder: String, borderStyle: UITextField.BorderStyle = .roundedRect) {
        self.init()
        self.placeholder = placeholder
        self.borderStyle = borderStyle
    }
}
