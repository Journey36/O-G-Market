//
//  DetailViewController.swift
//  O-G-Market
//

import Foundation
import UIKit
import SnapKit
import SwiftUI

let zeroSize = CGRect.zero

class DetailViewController: UIViewController {
//    let collectionView = DetailCompositionalViewController(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height))
    
    let productImagePageView = ProductImagePageView(frame: zeroSize, images: [])
    let productPriceView = ProductPriceView(frame: zeroSize)
    let productInfoView = ProductInfoView(frame: zeroSize)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(collectionView)
        self.view.addSubview(productPriceView)
        self.view.addSubview(productImagePageView)
        self.view.addSubview(productInfoView)
        
//        collectionView.snp.makeConstraints { make in
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.top.equalTo(view)
//            make.bottom.equalToSuperview()
//        }
        productPriceView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        productImagePageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        productInfoView.snp.makeConstraints { make in
            make.top.equalTo(productImagePageView.snp.bottom)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
    }
    
    
}

//extension DetailViewController: UICollectionViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("sroll!")
//    }
//}




// Preview
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = DetailViewController

    func makeUIViewController(context: Context) -> DetailViewController {
        return DetailViewController()
    }

    func updateUIViewController(_ uiViewController: DetailViewController, context: Context) {

    }
}

@available(iOS 13.0.0, *)
struct ViewPreview: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
    
    struct Container: UIViewControllerRepresentable {
        typealias UIViewControllerType = UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            UINavigationController(rootViewController: DetailViewController())
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
