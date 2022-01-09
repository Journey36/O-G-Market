//
//  ProductEditViewController.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/03.
//

import UIKit

class ProductEditViewController: UIViewController {
    let scrollView = UIScrollView()
    let pixelLineView = PixelLineView(frame: CGRect.zero)
    let addProductImageScrollView = AddProductImageScrollView()
    let nameTextField = UITextView()
    let priceEditView = ProductPriceEditView()
    let stockTextView = UITextView()
    let descriptionTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(pixelLineView)
        pixelLineView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(PixelLineView.height)
        }
        
        view.addSubview(priceEditView)
        priceEditView.backgroundColor = .brown
        priceEditView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
    

}

/*
 - 상품명
 - 가격
 - 할인률 1~100
 - 화폐
 - 남은 수량
 - 상품 상세
 
 - 백버튼
 - 상품 등록/수정 버튼 (하단)
 */
