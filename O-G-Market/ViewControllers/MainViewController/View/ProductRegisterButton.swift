//
//  ProductRegisterButton.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/29.
//

import UIKit

class ProductRegisterButton: UIButton {
    var coordinator: MainCoordinator?
    
    convenience init(coordinator: MainCoordinator?) {
        self.init(frame: CGRect.zero)
        let buttonImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .bold))
        
        self.coordinator = coordinator
        self.setImage(buttonImage, for: .normal)
        self.backgroundColor = .systemBlue
        self.tintColor = .white
        self.layer.cornerRadius = 35
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.addTarget(self, action: #selector(presentProductRegisterViewController), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func presentProductRegisterViewController() {
        coordinator?.presentEditViewController()
    }

}
