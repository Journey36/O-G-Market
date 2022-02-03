//
//  DeleteViewController.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/02/04.
//

import UIKit

class DeleteAlertController: UIAlertController {
    var productDeletionInfo: ProductDeletion?
    
    convenience init(productDeletionInfo: ProductDeletion) {
        self.init(title: "상품 삭제", message: "삭제하면 되돌릴 수 없습니다! 신중하게 선택해주세요.", preferredStyle: .alert)
        self.productDeletionInfo = productDeletionInfo
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addActions()
        addPasswordTextField()
    }
    
    private func addActions() {
        let cancelAction = UIAlertAction(title: "취소하기", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { alert in
            // TODO: 상품 삭제 요청
            self.deleteProduct()
            self.dismiss(animated: true, completion: nil)
        }
        
        self.addAction(deleteAction)
        self.addAction(cancelAction)
    }
    
    private func addPasswordTextField() {
        self.addTextField { textField in
            textField.placeholder = "비밀 번호를 입력해주세요."
        }
    }
    
    private func deleteProduct() {
        // TODO: 상품 삭제 요청
    }
}
