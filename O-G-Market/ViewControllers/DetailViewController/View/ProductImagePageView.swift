//
//  ProductImagePageView.swift
//  O-G-Market
//
//  Created by odongnamu on 2021/12/31.
//

import UIKit

class ProductImagePageView: UICollectionView {
    var coordinator: MainCoordinator?
    var images: [UIImage]?
    
    init(frame: CGRect, images: [UIImage]) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        self.images = images
        
        self.register(ProductImageCollectionViewCell.self, forCellWithReuseIdentifier: ProductImageCollectionViewCell.id)
        
        self.isPagingEnabled = true
        self.isScrollEnabled = true
        self.dataSource = self
        self.delegate = self
        self.collectionViewLayout = createLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
}

extension ProductImagePageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 임시 값 3
        if let images = images {
            return images.count
        } else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCollectionViewCell.id, for: indexPath) as? ProductImageCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .systemGray5
        cell.imageView.image = images![indexPath.row]
        return cell
    }
    
}

extension ProductImagePageView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 화면 전환 후 현재 이미지 먼저 보여주기
        coordinator?.presentImageViewerController(images: images)
    }
}

extension ProductImagePageView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
