//
//  SignUpViewController.swift
//  O-G-Market
//
//  Created by 재현 on 2021/12/26.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController {
    // MARK: - Properties
    var keyboardHeight: CGFloat?
    let textFieldStackView: UIStackView = {
        let textFieldStackView = UIStackView()
        textFieldStackView.axis = .vertical
        textFieldStackView.distribution = .equalSpacing
        textFieldStackView.spacing = 10
        return textFieldStackView
    }()

    let userNameTextField: UITextField = {
        let userNameTextField = UITextField()
        userNameTextField.borderStyle = .roundedRect
        userNameTextField.clearButtonMode = .whileEditing
        userNameTextField.placeholder = "이름을 입력해주세요."

        return userNameTextField
    }()

    let userAccessIDTextField: UITextField = {
        let userAccessIDTextField = UITextField()
        userAccessIDTextField.borderStyle = .roundedRect
        userAccessIDTextField.clearButtonMode = .whileEditing
        userAccessIDTextField.placeholder = "아이디를 입력해주세요."
        return userAccessIDTextField
    }()

    let userSecretTextField: UITextField = {
        let userSecretTextField = UITextField()
        userSecretTextField.borderStyle = .roundedRect
        userSecretTextField.clearButtonMode = .whileEditing
        // FIXME: - Password Autofill
        userSecretTextField.isSecureTextEntry = true
//        userSecretTextField.textContentType = .password
        userSecretTextField.placeholder = "비밀번호를 입력해주세요."
        return userSecretTextField
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureHierachy()
        configureConstraints()
        userNameTextField.delegate = self
        userAccessIDTextField.delegate = self
        userSecretTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Methods
    private func configureHierachy() {
        view.addSubview(textFieldStackView)

        textFieldStackView.addArrangedSubview(userNameTextField)
        textFieldStackView.addArrangedSubview(userAccessIDTextField)
        textFieldStackView.addArrangedSubview(userSecretTextField)
    }

    private func configureConstraints() {
        textFieldStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }

    @objc private func keyboardWillAppear(_ sender: Notification) {
        guard let userInfo = sender.userInfo else { return }
        let keyboardFrame = (userInfo as NSDictionary).value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue
        let keyboardRect = keyboardFrame?.cgRectValue
        let keyboardHeight = keyboardRect?.height
        self.keyboardHeight = keyboardHeight

        self.view.frame.size.height -= self.keyboardHeight ?? .zero
    }

    @objc private func keyboardWillDisappear(_ sender: Notification) {
        self.view.frame.size.height += self.keyboardHeight ?? .zero
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case userNameTextField:
            textField.resignFirstResponder()
            userAccessIDTextField.becomeFirstResponder()
        case userAccessIDTextField:
            textField.resignFirstResponder()
            userSecretTextField.becomeFirstResponder()
        case userSecretTextField:
            textField.resignFirstResponder()
        default:
            break
        }

        return true
    }
}
