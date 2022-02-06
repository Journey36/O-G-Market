//
//  ProductImagePageView.swift
//  O-G-Market
//
//  Created by odongnamu on 2021/12/31.
//

import UIKit

class ProductImagePageViewController: UIViewController {
    var coordinator: MainCoordinator?
    var images: [UIImage] = []
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
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    private func configureCollectionView() {
        collectionView.register(ProductImageCollectionViewCell.self, forCellWithReuseIdentifier: ProductImageCollectionViewCell.id)
        
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
    }
    
    func setUpComponentsData(product: ProductDetails) {
        product.images.forEach { image in
            guard let url = URL(string: image.url) else { return }
            Networking.default.getProductImages(url: url) { result in
                switch result {
                case .success(let image):
                    self.images.append(image)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    return
                }
            }
        }
    }
}

extension ProductImagePageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let images = images else { return 0 }
//
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCollectionViewCell.id, for: indexPath) as? ProductImageCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .systemGray5
        cell.imageView.image = images[indexPath.row]
        return cell
    }
}

extension ProductImagePageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 화면 전환 후 현재 이미지 먼저 보여주기
        coordinator?.presentImageViewerController(sender: self, images: images)
    }
}

extension ProductImagePageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
