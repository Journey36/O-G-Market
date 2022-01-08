//
//  1pxLineView.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/08.
//

import Foundation
import UIKit

class PixelLineView: UIView {
    let lineView = UIView()
    let lineHeight = 0.5
    static let height = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLineView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLineView() {
        addSubview(lineView)
        
        lineView.backgroundColor = .lightGray
        lineView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(lineHeight)
        }
    }
}


