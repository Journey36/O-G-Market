//
//  ProductEditViewController.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/03.
//

import UIKit

final class ProductEditViewController: UIViewController {
    enum ViewType {
        case regist
        case edit

        var title: String {
            switch self {
            case .regist: return "상품 등록"
            case .edit: return "상품 수정"
            }
        }
    }

    var coordinator: MainCoordinator?
    private var productID: Int?
    private var capturedValue: [String: Any] = [:]
    private var type: ViewType
    private let manager = NetworkManager()

    let addProductImageCollectionViewController = AddProductImageCollectionViewController()
    private let productNameTextField = UITextField(placeholder: "상품 이름을 입력해주세요.")
    private let productPriceTextField = UITextField(placeholder: "상품 가격을 입력해주세요.")
    private let productDiscountedPriceTextField = UITextField(placeholder: "할인 가격을 입력해주세요.")
    private let productStockTextField = UITextField(placeholder: "상품 갯수를 입력해주세요.")
    private let currencySegmentControl: UISegmentedControl = {
        let currencySegmentControl = UISegmentedControl(items: ["KRW", "USD"])
        return currencySegmentControl
    }()
    private let priceStackView = UIStackView(axis: .horizontal, alignment: .center, spacing: 10)
    private let contentsStackView = UIStackView(axis: .vertical, alignment: .leading, spacing: 10, distribution: .fill)
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#736047")
        button.titleLabel?.font = .preferredFont(forTextStyle: .title3)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(enrollProduct), for: .touchUpInside)
        return button
    }()
    private let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "상품 정보를 입력해주세요."
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.font = .preferredFont(forTextStyle: .body)

        return textView
    }()

    init(type: ViewType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)

        registerButton.setTitle("\(type.title)하기", for: .normal)
        navigationItem.title = type.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        productNameTextField.delegate = self
        productPriceTextField.delegate = self
        productDiscountedPriceTextField.delegate = self
        productStockTextField.delegate = self

        addSubviews()
        configureNavigationBar()
        configureLayout()
        captureValue()
    }

    private func addSubviews() {
        priceStackView.addArrangedSubview(productPriceTextField)
        priceStackView.addArrangedSubview(currencySegmentControl)

        contentsStackView.addArrangedSubview(addProductImageCollectionViewController.view)
        contentsStackView.addArrangedSubview(productNameTextField)
        contentsStackView.addArrangedSubview(priceStackView)
        contentsStackView.addArrangedSubview(productDiscountedPriceTextField)
        contentsStackView.addArrangedSubview(productStockTextField)
        contentsStackView.addArrangedSubview(productDescriptionTextView)
        contentsStackView.addArrangedSubview(registerButton)

        view.addSubview(contentsStackView)
    }

    private func configureNavigationBar() {
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissSelf))
        cancelButton.tintColor = .lightGray
        navigationItem.rightBarButtonItem = cancelButton
    }

    @objc func dismissSelf() {
        coordinator?.dismissModal(sender: self)
    }

    @objc func enrollProduct() {
        guard checkRequiredValueValidity() else { return }
        switch type {
        case .regist:
            guard let product = package() else { return }
            Task {
                guard (try? await manager.upload(content: product)) != nil else { return }
                dismissSelf()
            }

        case .edit:
            guard let parameters = revise(), let productID = self.productID else { return }
            Task {
                guard (try? await manager.update(productID: productID, content: parameters)) != nil else { return }
                dismissSelf()
            }
        }
    }

    // MARK: - 수정
    private func revise() -> Update? {
        guard let name = productNameTextField.text else { return nil }
        guard let description = productDescriptionTextView.text else { return nil }
        guard let priceText = productPriceTextField.text, let price = Double(priceText) else { return nil }
        let currency = currencySegmentControl.selectedSegmentIndex == 0 ? Currency.KRW : Currency.USD
        guard let discountedPriceText = productDiscountedPriceTextField.text, let discountedPrice = Double(discountedPriceText) else { return nil }
        guard let stockText = productStockTextField.text, let stock = Int(stockText) else { return nil }

        return Update(name: name == capturedValue["productNameTextField"] as? String ? nil : name,
                             descriptions: description == capturedValue["productDescriptionTextView"] as? String ? nil : description,
                             thumbnailID: nil,
                             price: price == capturedValue["productPriceTextField"] as? Double ? nil : price,
                             currency: currency == capturedValue["currencySegmentControl"] as? Currency ? nil : currency,
                             discountedPrice: discountedPrice == capturedValue["productDiscountedPriceTextField"] as? Double ? nil : discountedPrice,
                             stock: stock == capturedValue["productStockTextField"] as? Int ? nil : stock,
                             secret: Bundle.main.password)
    }

    private func captureValue() {
        guard let name = productNameTextField.text else { return }
        guard let description = productDescriptionTextView.text else { return }
        guard let priceText = productPriceTextField.text, let price = Double(priceText) else { return }
        guard let discountedPriceText = productDiscountedPriceTextField.text, let discountedPrice = Double(discountedPriceText) else { return }
        guard let stockText = productStockTextField.text, let stock = Int(stockText) else { return }

        capturedValue["productNameTextField"] = name
        capturedValue["productDescriptionTextView"] = description
        capturedValue["productPriceTextField"] = price
        capturedValue["currencySegmentControl"] = currencySegmentControl.selectedSegmentIndex == 0 ? Currency.KRW : Currency.USD
        capturedValue["productDiscountedPriceTextField"] = discountedPrice
        capturedValue["productStockTextField"] = stock
    }

    // MARK: - 생성
    private func package() -> Registration? {
        guard let name = productNameTextField.text else {
            return nil
        }

        guard let priceText = productPriceTextField.text, let price = Double(priceText) else {
            return nil
        }

        let currency = currencySegmentControl.selectedSegmentIndex == 0 ? Currency.KRW : Currency.USD
        guard let text = productDiscountedPriceTextField.text, let discountedPrice = Double(text) else {
            return nil
        }

        guard let stockText = productStockTextField.text, let stock = Int(stockText) else {
            return nil
        }

        guard let description = productDescriptionTextView.text else {
            return nil
        }

        let product = Product(name: name, descriptions: description, price: price, currency: currency, discountedPrice: discountedPrice, stock: stock, secret: Bundle.main.password)
        let images = addProductImageCollectionViewController.imageList.compactMap { $0.jpegData(compressionQuality: 0.1) }

        return Registration(product: product, images: images)
    }

    private func checkRequiredValueValidity() -> Bool {
        guard !addProductImageCollectionViewController.imageList.isEmpty else {
            coordinator?.presentBasicAlert(sender: self, message: "이미지를 1장 이상 등록해주세요!")
            return false
        }

        guard (10...1000).contains(productDescriptionTextView.text.count) else {
            coordinator?.presentBasicAlert(sender: self,
                                           message: "상품 설명을 10자 이상, 1000자 이하로 입력해주세요!")
            return false
        }

        guard currencySegmentControl.selectedSegmentIndex >= 0 && currencySegmentControl.selectedSegmentIndex <= currencySegmentControl.numberOfSegments else {
            coordinator?.presentBasicAlert(sender: self, message: "통화를 선택해주세요!")
            return false
        }

        guard !(productNameTextField.text?.isEmpty ?? false),
              !(productPriceTextField.text?.isEmpty ?? false),
              !(productStockTextField.text?.isEmpty ?? false),
              !(productDiscountedPriceTextField.text?.isEmpty ?? false) else {
                  coordinator?.presentBasicAlert(sender: self, message: "모든 필드를 채워주세요!")
                  return false
              }

        return true
    }

    private func configureLayout() {
        contentsStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }

        addProductImageCollectionViewController.view.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
        }

        productNameTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        productPriceTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.7)
        }

        productDiscountedPriceTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        priceStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        productStockTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        productDescriptionTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        registerButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
    }
}

extension ProductEditViewController {
    func setUpComponentsData(product: Post?, images: [UIImage]) {
        guard type == .edit, let product = product else { return }
        productID = product.id
        productNameTextField.text = product.name
        productPriceTextField.text = composePrice(of: product)
        productDiscountedPriceTextField.text = composeDiscountedPrice(of: product)
        productDescriptionTextView.text = product.description
        productStockTextField.text = String(product.stock)
        currencySegmentControl.selectedSegmentIndex = product.currency == .KRW ? 0 : 1
        addProductImageCollectionViewController.imageList = images
    }

    private func composePrice(of product: Post) -> String? {
        var priceText = String(product.price)
        guard let textStartIndex = priceText.firstIndex(of: ".") else { return nil }
        let textEndIndex = priceText.endIndex
        let bounds = textStartIndex..<textEndIndex

        if priceText.hasSuffix(".0") {
            priceText.removeSubrange(bounds)
        }

         return priceText
    }

    private func composeDiscountedPrice(of product: Post) -> String? {
        var discountedPriceText = String(product.discountedPrice)
        guard let textStartIndex = discountedPriceText.firstIndex(of: ".") else { return nil }
        let textEndIndex = discountedPriceText.endIndex
        let bounds = textStartIndex..<textEndIndex
        discountedPriceText.removeSubrange(bounds)
        return discountedPriceText
    }
}

extension ProductEditViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }
        guard let textRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)

        checkTextLengthValidity(of: textField, currentText: currentText, updatedText: updatedText)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        checkTextValidity(of: textField)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case productNameTextField:
            textField.resignFirstResponder()
            productPriceTextField.becomeFirstResponder()
        case productPriceTextField:
            textField.resignFirstResponder()
            productDiscountedPriceTextField.becomeFirstResponder()
        case productDiscountedPriceTextField:
            textField.resignFirstResponder()
            productStockTextField.becomeFirstResponder()
        case productStockTextField:
            textField.resignFirstResponder()
            productDescriptionTextView.becomeFirstResponder()
        default:
            break
        }

        return true
    }
}

extension ProductEditViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        let cursorPosition = textView.endOfDocument
        textView.selectedTextRange = textView.textRange(from: cursorPosition, to: cursorPosition)
    }
}

extension ProductEditViewController {
    private func checkTextLengthValidity(of textField: UITextField, currentText: String,
                                         updatedText: String) {
        let becomeFirstResponder: ((UIAlertAction) -> Void)? = { _ in
            textField.becomeFirstResponder()
        }

        switch textField {
        case productNameTextField:
            guard (0...50).contains(updatedText.count) else {
                coordinator?.presentBasicAlert(sender: self,
                                               message: "제품 이름을 최대 50자 이내로 입력해주세요!",
                                               handler: becomeFirstResponder)
                textField.text = currentText
                return
            }
        case productPriceTextField:
            guard (0...12).contains(updatedText.count) else {
                coordinator?.presentBasicAlert(sender: self,
                                               message:
                                                "상품 가격을 12자리 이하로 입력해주세요!\n(최대 1000억)",
                                               handler: becomeFirstResponder)
                textField.text = currentText
                return
            }
        case productDiscountedPriceTextField:
            guard (0...3).contains(updatedText.count) else {
                coordinator?.presentBasicAlert(sender: self,
                                               message: "상품 할인률을 입력해주세요!\n(최대 100%)", handler: becomeFirstResponder)
                textField.text = currentText
                return
            }
        case productStockTextField:
            guard (0...8).contains(updatedText.count) else {
                coordinator?.presentBasicAlert(sender: self,
                                               message:
                                                "상품 재고를 8자리 이하로 입력해주세요!\n(최대 99,999,999개)",
                                               handler: becomeFirstResponder)
                textField.text = currentText
                return
            }
        default:
            break
        }
    }

    private func checkTextValidity(of textField: UITextField) {
        guard let currentText = textField.text else { return }
        let becomeFirstResponder: ((UIAlertAction) -> Void)? = { _ in
            textField.becomeFirstResponder()
        }

        switch textField {
        case productPriceTextField:
            let regularExpressionForInteger = "^[1-9][\\d]*$"
            let regularExpressionForDouble = "^(([1-9][\\d]*\\.)|([0.]))[\\d]*[^0^\\.\\W]$"
            if Int(currentText) == nil {
                guard currentText.range(of: regularExpressionForDouble,
                                            options: .regularExpression) != nil else {
                    coordinator?.presentBasicAlert(sender: self,
                                                   message:
                                                    "올바른 가격을 입력해주세요!",
                                                   handler: becomeFirstResponder)
                    textField.text = nil
                    return
                }
            } else {
                guard currentText.range(of: regularExpressionForInteger,
                                            options: .regularExpression) != nil else {
                    coordinator?.presentBasicAlert(sender: self,
                                                   message:
                                                    "올바른 가격을 입력해주세요!",
                                                   handler: becomeFirstResponder)
                    textField.text = nil
                    return
                }
            }
        case productDiscountedPriceTextField:
            if let number = Int(currentText) {
                guard (0...100).contains(number) else {
                    coordinator?.presentBasicAlert(sender: self,
                                                   message: "할인율을 올바르게 입력해주세요!",
                                                   handler: becomeFirstResponder)
                    textField.text = nil
                    return
                }
            }
            return
        case productStockTextField:
            let regularExpression = "^0$|^[1-9][\\d]*$"
            guard currentText.range(of: regularExpression,
                                    options: .regularExpression) != nil else {
                coordinator?.presentBasicAlert(sender: self,
                                               message: "올바른 상품 재고를 입력해주세요!",
                                               handler: becomeFirstResponder)
                textField.text = nil
                return
            }
        default:
            break
        }
    }
}
