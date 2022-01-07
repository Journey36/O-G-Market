//
//  DetailViewController.swift
//  O-G-Market
//

import Foundation
import UIKit
import SnapKit
import SwiftUI

fileprivate let zeroSize = CGRect.zero

class DetailViewController: UIViewController {
    let scrollView = UIScrollView()
    let productImagePageView = ProductImagePageView(frame: zeroSize, images: [])
    let productPriceView = ProductPriceView(frame: zeroSize)
    let productInfoView = ProductInfoView(frame: zeroSize)

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        configureNavigationBar()
        configureLayout()
    }

    private func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(productPriceView)
        
        scrollView.addSubview(productImagePageView)
        scrollView.addSubview(productInfoView)
    }

    private func configureLayout() {
        // Scroll View로 수정해야함.
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
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }

        productInfoView.snp.makeConstraints { make in
            make.top.equalTo(productImagePageView.snp.bottom)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalTo(productPriceView.snp.top)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(productPriceView.snp.top)
        }
    }
}

// MARK: NavigationBar
extension DetailViewController {
    private func configureNavigationBar() {
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(showActivityView))
        let editButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(showEditActionSheet))
        
        navigationItem.rightBarButtonItems = [editButton, shareButton]
        navigationItem.title = "상품 상세"
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    @objc private func showActivityView() {
        let activityViewController = UIActivityViewController(activityItems: ["오동나무"], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItems?.first
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func showEditActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: "Edit Product", preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "수정하기", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default, handler: nil)
    
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}



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
