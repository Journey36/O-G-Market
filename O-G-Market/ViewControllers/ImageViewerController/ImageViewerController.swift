//
//  ImageViewerController.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/02/02.
//

import UIKit
import SwiftUI

class ImageViewerController: UIViewController {
    var images: [UIImage]?
    let imageView = UIImageView()
    
    let xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .lightGray
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        
        return button
    }()
    
    let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.isPagingEnabled = true
        collectionView.register(ZoomableCollectionViewCell.self, forCellWithReuseIdentifier: ZoomableCollectionViewCell.id)
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self

        addSubviews()
        configureLayout()
    }
    
    private func addSubviews() {
        view.addSubview(imageCollectionView)
        view.addSubview(xButton)
    }
    
    private func configureLayout() {
        self.imageCollectionView.snp.makeConstraints({ make in
            make.size.equalTo(self.view.safeAreaLayoutGuide)
            make.center.equalTo(self.view.safeAreaLayoutGuide)
        })
        
        self.xButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
    }
}

extension ImageViewerController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: ZoomableCollectionViewCell.id, for: indexPath) as? ZoomableCollectionViewCell else { return UICollectionViewCell() }
//        cell.imageView.image = images?[indexPath.row]
        // 임시 코드
        cell.imageView.image = UIImage(systemName: "pencil")
        return cell
    }
}

extension ImageViewerController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = collectionView.frame.size
        size.height = view.safeAreaLayoutGuide.layoutFrame.height
        
        return size
    }
}
