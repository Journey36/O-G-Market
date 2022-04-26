//
//  DeleteViewController.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/02/04.
//

import UIKit

class ProductDeleteAlertController: UIAlertController {
    var productID: Int?
    private let communicator = Network()

    convenience init(productID: Int) {
        self.init(title: "상품 삭제", message: "삭제하면 되돌릴 수 없습니다! 신중하게 선택해주세요.", preferredStyle: .alert)
        self.productID = productID
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addDeleteAction()
        addCancelAction()
        addPasswordTextField()
    }

    private func addDeleteAction() {
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.inquireProductSecret()
        }

        self.addAction(deleteAction)
    }

    private func addCancelAction() {
        let cancelAction = UIAlertAction(title: "취소하기", style: .cancel)

        self.addAction(cancelAction)
    }

    private func addPasswordTextField() {
        self.addTextField { textField in
            textField.placeholder = "비밀 번호를 입력해주세요."
            textField.isSecureTextEntry = true
        }
    }
}

extension ProductDeleteAlertController {
    private func inquireProductSecret() {
        guard let productID = productID else { return }
        guard let userSecretKeyTextField = textFields?.first, let userSecretKey = userSecretKeyTextField.text else { return }

        Task {
            guard let productSecretKey = try? await self.communicator.inquireSecretKey(of: productID, with: userSecretKey) else { throw Network.NetworkError.badRequest }
            self.deleteProduct(productSecretKey: productSecretKey)
        }
    }


    private func deleteProduct(productSecretKey: String) {
        guard let productID = productID else { return }

        Task {
            try await communicator.deletePost(of: productID, coincideWith: productSecretKey)
        }
    }
}
