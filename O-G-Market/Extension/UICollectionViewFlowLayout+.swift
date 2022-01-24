//
//  UICollectionViewFlowLayout+.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/24.
//

import UIKit

extension UICollectionViewFlowLayout {
    convenience init(scrollDirection: UICollectionView.ScrollDirection) {
        self.init()
        self.scrollDirection = scrollDirection
    }
}
