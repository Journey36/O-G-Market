//
//  AddProductImageView.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/03.
//

/*
 Feature
 - 이미지 추가시 레이아웃 업데이트
 - 첫 번째 버튼은 add 버튼
 - 뒤에 나열되는 이미지 탭할 경우 이미지 확대 보기
 - 이미지 삭제 버튼
 - 이미지 용량 제한
 */

import UIKit

class AddProductImageCollectionViewController: UIViewController {
    var imageList = [UIImage]()
    var numberOfCell = 5
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    convenience init(images: [UIImage]) {
        self.init()
        self.imageList = images
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AddImageCell.self, forCellWithReuseIdentifier: AddImageCell.id)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        addSubviews()
        configureLayout()
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

class MyCell: UICollectionViewCell {
    static let id = "test"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddProductImageCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageCell.id, for: indexPath)
        return cell
    }
    
    
}

extension AddProductImageCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        numberOfCell += 1
        collectionView.reloadData()
    }
}

extension AddProductImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 75)
    }
}
