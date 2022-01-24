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
    let addProductImageCollectionViewController = AddProductImageCollectionViewController(images: [UIImage(systemName: "pencil")!, UIImage(systemName: "circle")!])
    let nameTextView = UITextView()
    let priceEditView = ProductPriceEditView()
    let stockTextView = UITextView()
    let descriptionTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        priceEditView.backgroundColor = .red
        
        navigationItem.title = "상품 등록"
        addSubviews()
        configureLayout()
    }
    
    private func addSubviews() {
        scrollView.addSubview(addProductImageCollectionViewController.view)
        scrollView.addSubview(nameTextView)
        scrollView.addSubview(priceEditView)
        scrollView.addSubview(stockTextView)
        scrollView.addSubview(descriptionTextView)
        
        view.addSubview(scrollView)
    }
    
    private func configureLayout() {
        let pixelLineView1 = PixelLineView(frame: CGRect.zero)
        let pixelLineView2 = PixelLineView(frame: CGRect.zero)
        let pixelLineView3 = PixelLineView(frame: CGRect.zero)
        let pixelLineView4 = PixelLineView(frame: CGRect.zero)
        let pixelLineView5 = PixelLineView(frame: CGRect.zero)
        scrollView.addSubview(pixelLineView1)
        scrollView.addSubview(pixelLineView2)
        scrollView.addSubview(pixelLineView3)
        scrollView.addSubview(pixelLineView4)
        scrollView.addSubview(pixelLineView5)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addProductImageCollectionViewController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(100)
        }
        
        pixelLineView1.snp.makeConstraints { make in
            make.top.equalTo(addProductImageCollectionViewController.view.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        nameTextView.snp.makeConstraints { make in
            make.top.equalTo(pixelLineView1.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(40)
            // 텍스트 높이에 따라 동적으로 변해야함
        }
        
        pixelLineView2.snp.makeConstraints { make in
            make.top.equalTo(nameTextView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        priceEditView.snp.makeConstraints { make in
            make.top.equalTo(pixelLineView2.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(40)
            // 할인 여부에 따라 동적으로 변해야함
        }
        
        pixelLineView3.snp.makeConstraints { make in
            make.top.equalTo(priceEditView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        stockTextView.snp.makeConstraints { make in
            make.top.equalTo(pixelLineView3.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(40)
            // 할인 여부에 따라 동적으로 변해야함
        }
        
        pixelLineView4.snp.makeConstraints { make in
            make.top.equalTo(stockTextView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(pixelLineView4.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(40)
            // 할인 여부에 따라 동적으로 변해야함
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
