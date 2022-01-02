//
//  DetailCompositionalViewController.swift
//  O-G-Market
//
//  Created by odongnamu on 2021/12/26.
//

import UIKit

private let reuseIdentifier = "Cell"

class DetailCompositionalViewController: UICollectionView {
    
    override var delegate: UICollectionViewDelegate? {
            get { super.delegate }
            set {
                super.delegate = newValue
                subviews.forEach { (view) in
                    guard String(describing: type(of: view)) == "_UICollectionViewOrthogonalScrollerEmbeddedScrollView" else { return }
                    guard let scrollView = view as? UIScrollView else { return }
                    scrollView.delegate = newValue
                }
            }
        }
    
    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: Self.createLayout())
        configureNavigationBar()
        registerSomeViews()
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
//        navigationItem.title = "상품 상세"
    }
    
    private func registerSomeViews() {
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.register(ProductImageCollectionViewCell.self, forCellWithReuseIdentifier: ProductImageCollectionViewCell.id)
        self.register(ProductInfoCollectionViewCell.self, forCellWithReuseIdentifier: ProductInfoCollectionViewCell.id)
    }
}

extension DetailCompositionalViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCollectionViewCell.id, for: indexPath) as? ProductImageCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .lightGray
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductInfoCollectionViewCell.id, for: indexPath) as? ProductInfoCollectionViewCell else {
                return UICollectionViewCell()
            }
//            cell.backgroundColor = .lightGray
            return cell
        }
    }
}
