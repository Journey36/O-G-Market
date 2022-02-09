//
//  UIStackView+.swift
//  O-G-Market
//
//  Created by odongnamu on 2021/12/27.
//

import Foundation
import UIKit

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, spacing: CGFloat = 0, distribution: UIStackView.Distribution = .fill) {
        self.init()

        self.axis = axis
        self.alignment = alignment
        self.spacing = spacing
        self.distribution = distribution
    }
}
