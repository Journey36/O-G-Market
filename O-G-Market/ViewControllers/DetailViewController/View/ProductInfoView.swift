//
//  ProductInfoView.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/03.
//

import UIKit

class ProductInfoView: UIView {
    let titleLabel = UILabel(textStyle: .largeTitle)
    let registrationDateLabel = UILabel(textStyle: .body, textColor: .darkGray)
    let descriptionLabel = UILabel(textStyle: .body)
    let stackView = UIStackView(axis: .vertical, alignment: .leading, sapcing: 8)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView.distribution = .fillEqually
        addSubviews()
        configureLayout()
        
        // 임시 설정
        titleLabel.text = "오동나무의 뿌리"
        registrationDateLabel.text = "2021. 12. 25"
        descriptionLabel.text = "오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ"
        self.backgroundColor = .systemGray4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addSubviews() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(registrationDateLabel)
        stackView.addArrangedSubview(descriptionLabel)
        addSubview(stackView)
    }
}
