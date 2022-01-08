//
//  ProductEditViewController.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/03.
//

import UIKit

class ProductEditViewController: UIViewController {
    let tableView = UITableView()
    let pixelLineView = PixelLineView(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(pixelLineView)
        pixelLineView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(PixelLineView.height)
        }
    }
    

}
