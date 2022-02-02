//
//  ImageViewerController.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/02/02.
//

import UIKit

class ImageViewerController: UIViewController {
    var images: [UIImage]?
    let imageCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    let imageView = UIImageView()
    let xButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        imageCollectionView.backgroundColor = .black
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.isPagingEnabled = true
        imageCollectionView.collectionViewLayout = createLayout()
        
        imageCollectionView.register(ZoomableCollectionViewCell.self, forCellWithReuseIdentifier: ZoomableCollectionViewCell.id)
        
        xButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        xButton.tintColor = .lightGray
        
        addSubviews()
        configureLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    private func addSubviews() {
        view.addSubview(imageCollectionView)
        view.addSubview(xButton)
    }
    
    private func configureLayout() {
        self.imageCollectionView.snp.makeConstraints({
            $0.size.equalTo(self.view.safeAreaLayoutGuide)
            $0.center.equalTo(self.view.safeAreaLayoutGuide)
        })
        
        self.xButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 50, height: 50))
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
