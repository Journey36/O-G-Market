//
//  DetailViewController.swift
//  O-G-Market
//

import Foundation
import UIKit
import SnapKit
import SwiftUI

private let zeroSize = CGRect.zero

class DetailViewController: UIViewController {
    var coordinator: MainCoordinator?
    var product: ProductDetails?

    let scrollView = UIScrollView()
    let productImagePageViewController = ProductImagePageViewController()
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

        scrollView.addSubview(productImagePageViewController.view)
        scrollView.addSubview(productInfoView)
    }

    private func configureLayout() {
        productPriceView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        productImagePageViewController.view.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(view.snp.width)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }

        productInfoView.snp.makeConstraints { make in
            make.top.equalTo(productImagePageViewController.view.snp.bottom)
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

    func setUpComponentsData(product: ProductDetails) {
        self.product = product

        productInfoView.setUpComponentsData(product: product)
        productPriceView.setUpComponentsData(product: product)
        productImagePageViewController.setUpComponentsData(product: product)
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
        coordinator?.presentActivityViewController(sender: self)
    }

    @objc private func showEditActionSheet() {
        coordinator?.presentEditActionSheet(product: product, images: productImagePageViewController.images)
    }
}
