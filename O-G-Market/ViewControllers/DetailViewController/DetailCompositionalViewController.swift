//
//  DetailCompositionalViewController.swift
//  O-G-Market
//
//  Created by odongnamu on 2021/12/26.
//

import UIKit

private let reuseIdentifier = "Cell"

class DetailCompositionalViewController: UICollectionViewController {
    
    init() {
        super.init(collectionViewLayout: Self.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        registerSomeViews()
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, collectionLayoutEnvironment in
            
            if sectionNumber == 0 {
                return DetailViewCompositionalLayoutSections.productImagesSection
            } else {
                return DetailViewCompositionalLayoutSections.productInfoSection
            }
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "상품 상세"
    }
    
    private func registerSomeViews() {
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

// MARK: UICollectionViewDataSource
extension DetailCompositionalViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            // Number of Product Images
            return 3
        } else if section == 1 {
            // Product Information
            return 1
        } else {
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .lightGray
        return cell
    }
}



