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
    var coordinator: Coordinator?
    
    let scrollView = UIScrollView()
    let productImagePageView = ProductImagePageView(frame: zeroSize, images: [])
    let productPriceView = ProductPriceView(frame: zeroSize)
    let productInfoView = ProductInfoView(frame: zeroSize)
    let contentsView = UIView(frame: zeroSize)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

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
        productPriceView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        productImagePageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(view.snp.width)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }

        productInfoView.snp.makeConstraints { make in
            make.top.equalTo(productImagePageView.snp.bottom)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
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
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive, handler: nil)
        let cancelButton = UIAlertAction(title: "취소하기", style: .cancel, handler: nil)
    
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelButton)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}
