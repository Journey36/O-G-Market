//
//  UILabel+.swift
//  O-G-Market
//
//  Created by odongnamu on 2021/12/26.
//

import UIKit

extension UILabel {
    convenience init(textStyle: UIFont.TextStyle, textColor: UIColor = UIColor(named: "TextColor") ?? .black) {
        self.init()
        self.font = .preferredFont(forTextStyle: textStyle)
        self.textColor = textColor
    }
}
