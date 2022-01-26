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
    let stackView = UIStackView(axis: .vertical, alignment: .leading, spacing: 8, distribution: .equalSpacing)
    let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        configureLayout()
        descriptionLabel.numberOfLines = 0
        
        // 임시 설정
        self.backgroundColor = .systemGray4

        titleLabel.text = "오동나무의 뿌리"
        registrationDateLabel.text = "등록일자: 2021. 12. 25"
        descriptionLabel.text = "오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ오동나무의 뿌리 팝니다. 먼저 사는 사람이 임자!! 하나 밖에 안남았대요 ㅜ"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
//        stackView.snp.makeConstraints { make in
//            make.width.equalToSuperview().multipliedBy(0.8)
//            make.height.equalToSuperview().multipliedBy(0.8)
//            make.center.equalToSuperview()
//        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        registrationDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(registrationDateLabel.snp.bottom).offset(15)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        }
    }
    
    private func addSubviews() {
//        stackView.addArrangedSubview(titleLabel)
//        stackView.addArrangedSubview(registrationDateLabel)
//        stackView.addArrangedSubview(descriptionLabel)
//        addSubview(stackView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(registrationDateLabel)
        containerView.addSubview(descriptionLabel)
        addSubview(containerView)
    }
}
