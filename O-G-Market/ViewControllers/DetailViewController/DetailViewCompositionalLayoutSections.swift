//
//  ItemImagesLayoutSection.swift
//  O-G-Market
//
//  Created by odongnamu on 2021/12/26.
//

import UIKit

enum DetailViewCompositionalLayoutSections {
    // MARK: ProductImagesSection
    static let productImagesSection: NSCollectionLayoutSection = {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.trailing = 1
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.bottom = 10
        section.orthogonalScrollingBehavior = .paging
        
        section.visibleItemsInvalidationHandler = ({ (visibleItems, point, env) in
             print("print Scroll")
        })
        
        
        return section
    }()
    
    // MARK: ProductInfoSection
    static let productInfoSection: NSCollectionLayoutSection = {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(400)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = UIScreen.main.bounds.width * 0.04
        section.contentInsets.trailing = UIScreen.main.bounds.width * 0.04
        
        return section
    }()
}

