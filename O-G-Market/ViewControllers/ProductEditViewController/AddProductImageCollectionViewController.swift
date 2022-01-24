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


protocol DeleteDelegate {
    func deleteCell(image: UIImage)
}

class AddProductImageCollectionViewController: UIViewController {
    var imageList = [UIImage]()
//    var numberOfCell = 5
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
        collectionView.register(AddedImageCollectionViewCell.self, forCellWithReuseIdentifier: AddedImageCollectionViewCell.id)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        imageList.append(UIImage(systemName: "pencil")!)
        imageList.append(UIImage(systemName: "circle")!)
        imageList.append(UIImage(systemName: "xmark")!)
        
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

extension AddProductImageCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddedImageCollectionViewCell.id, for: indexPath) as? AddedImageCollectionViewCell else { return UICollectionViewCell() }
        
        // 임시 코드
//        cell.imageView.image = UIImage(systemName: "pencil")
        cell.imageView.image = imageList[indexPath.row]
        cell.backgroundColor = .lightGray
        cell.deleteDelegate = self
        return cell
    }
}

extension AddProductImageCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        numberOfCell += 1
        collectionView.reloadData()
    }
}

extension AddProductImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 75)
    }
}

extension AddProductImageCollectionViewController: DeleteDelegate {
    func deleteCell(image: UIImage) {
        // 중복 사진 없다는 가정 하에
        guard let index = imageList.firstIndex(of: image) else { return }
        imageList.remove(at: index)
        collectionView.reloadData()
    }
}
