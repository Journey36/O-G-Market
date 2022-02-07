//
//  AddProductImageView.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/03.
//

import UIKit
import PhotosUI

protocol DeleteDelegate {
    func deleteCell(image: UIImage)
}

class AddProductImageCollectionViewController: UIViewController {
    var coordinator: MainCoordinator?
    
    var imageList = [UIImage]()
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout(scrollDirection: .horizontal))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        configureLayout()
        configureCollectionView()
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AddImageCollectionViewCell.self, forCellWithReuseIdentifier: AddImageCollectionViewCell.id)
        collectionView.register(AddedImageCollectionViewCell.self, forCellWithReuseIdentifier: AddedImageCollectionViewCell.id)
    }
}

// MARK: - UICollectionViewDataSource
extension AddProductImageCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageCollectionViewCell.id, for: indexPath) as? AddImageCollectionViewCell else { return UICollectionViewCell() }
            cell.numberOfImageLabel.text = "\(imageList.count)/5"
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddedImageCollectionViewCell.id, for: indexPath) as? AddedImageCollectionViewCell else { return UICollectionViewCell() }
        
        // 임시 코드
        cell.imageView.image = imageList[indexPath.row - 1]
        cell.backgroundColor = .lightGray
        cell.deleteDelegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension AddProductImageCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard (0...4).contains(imageList.count) else {
                coordinator?.presentBasicAlert(sender: self, message: "이미지는 최대 5개까지 등록 가능합니다.")
                return
            }
            let selectableNumber = 5 - imageList.count

            coordinator?.presentPHPickerViewController(sender: self, selectionLimit: selectableNumber)
        } else {
            coordinator?.presentImageViewerController(sender: self, images: imageList)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AddProductImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.height * 0.8
        return CGSize(width: height, height: height)
    }
}

// MARK: - DeleteDelegate
extension AddProductImageCollectionViewController: DeleteDelegate {
    func deleteCell(image: UIImage) {
        // 중복 사진 없다는 가정 하에
        guard let index = imageList.firstIndex(of: image) else { return }
        imageList.remove(at: index)
        collectionView.reloadData()
    }
}

// MARK: - PHPickerViewControllerDelegate
extension AddProductImageCollectionViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProviders = results.map { $0.itemProvider }
        itemProviders.forEach { item in
            handleSelectedImage(item)
        }
    }
    
    private func handleSelectedImage(_ item: NSItemProvider) {
        guard item.canLoadObject(ofClass: UIImage.self) else { return }
        
        item.loadObject(ofClass: UIImage.self) { (image, error) in
            guard let selectedImage = image as? UIImage else { return }
            
            DispatchQueue.main.async {
                self.imageList.append(selectedImage)
                self.collectionView.reloadData()
            }
        }
    }
}
