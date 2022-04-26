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
    private var product: ProductDetails?
    private var productID: Int?
    private var capturedValue: [String: Any] = [:]
    private var type: ViewType
    private let communicator = Network()

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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

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
        guard isAllComponentsFull() else { return }
        switch type {
        case .regist:
            guard let product = package() else { return }
            Task {
                guard (try? await communicator.registerProduct(with: product)) != nil else { throw Network.NetworkError.badRequest }
                dismissSelf()
            }

        case .edit:
            guard let parameters = revise(), let productID = self.productID else { return }
            Task {
                guard (try? await communicator.updateInfo(of: productID, to: parameters)) != nil else { throw Network.NetworkError.badRequest }
                dismissSelf()
            }
        }
    }

    // MARK: - 수정
    private func revise() -> ProductUpdate? {
        guard let name = productNameTextField.text else { return nil }
        guard let description = productDescriptionTextView.text else { return nil }
        guard let priceText = productPriceTextField.text, let price = Double(priceText) else { return nil }
        let currency = currencySegmentControl.selectedSegmentIndex == 0 ? Currency.KRW : Currency.USD
        guard let discountedPriceText = productDiscountedPriceTextField.text, let discountedPrice = Double(discountedPriceText) else { return nil }
        guard let stockText = productStockTextField.text, let stock = Int(stockText) else { return nil }

        return ProductUpdate(name: name == capturedValue["productNameTextField"] as? String ? nil : name,
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
    private func package() -> ProductCreation? {
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

        return ProductCreation(product: product, images: images)
    }

    private func isAllComponentsFull() -> Bool {
        guard !addProductImageCollectionViewController.imageList.isEmpty else {
            coordinator?.presentBasicAlert(sender: self, message: "이미지는 1장 이상 등록해야 합니다.")
            return false
        }

        guard (10...1000).contains(productDescriptionTextView.text.count) else {
            coordinator?.presentBasicAlert(sender: self, message: "상품 설명은 10자 이상, 1000자 이하로 작성해야 합니다.")
            return false
        }

        guard currencySegmentControl.selectedSegmentIndex >= 0 && currencySegmentControl.selectedSegmentIndex <= currencySegmentControl.numberOfSegments else {
            coordinator?.presentBasicAlert(sender: self, message: "통화를 선택해주세요.")
            return false
        }

        guard !(productNameTextField.text?.isEmpty ?? false),
              !(productPriceTextField.text?.isEmpty ?? false),
              !(productStockTextField.text?.isEmpty ?? false),
              !(productDiscountedPriceTextField.text?.isEmpty ?? false) else {
                  coordinator?.presentBasicAlert(sender: self, message: "모든 필드를 채워주세요.")
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
    func setUpComponentsData(product: ProductDetails?, images: [UIImage]) {
        guard type == .edit, let product = product else { return }

        productID = product.id
        productNameTextField.text = product.name
        productPriceTextField.text = String(product.price)
        productDiscountedPriceTextField.text = String(product.bargainPrice)
        productDescriptionTextView.text = product.description
        productStockTextField.text = String(product.stock)
        currencySegmentControl.selectedSegmentIndex = product.currency == .KRW ? 0 : 1
        addProductImageCollectionViewController.imageList = images
    }
}
