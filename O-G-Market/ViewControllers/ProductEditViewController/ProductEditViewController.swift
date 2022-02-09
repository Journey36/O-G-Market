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
            case .regist:
                return "상품 등록"
            case .edit:
                return "상품 수정"
            }
        }
    }

    var coordinator: MainCoordinator?
    private var product: ProductDetails?

    private var type: ViewType
    let addProductImageCollectionViewController = AddProductImageCollectionViewController()
    private let productNameTextField = UITextField(placeholder: "상품명을 입력해주세요.")
    private let productPriceTextField = UITextField(placeholder: "상품 가격을 입력해주세요.")
    private let productDiscountedPriceTextField = UITextField(placeholder: "할인 가격을 입력해주세요.")
    private let productStockTextField = UITextField(placeholder: "상품 갯수를 입력해주세요.")
    private let currencySegmentControl = UISegmentedControl(items: ["KRW", "USD"])
    private let priceStackView = UIStackView(axis: .horizontal, alignment: .center, spacing: 10)
    private let contentsStackView = UIStackView(axis: .vertical, alignment: .leading, spacing: 10, distribution: .fill)
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#736047")
        button.titleLabel?.font = .preferredFont(forTextStyle: .title3)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(postProduct), for: .touchUpInside)

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

    @objc func postProduct() {
        isAllComponentsFull()
            // TODO: Post, Patch 하기
    }

    private func isAllComponentsFull() {
        guard addProductImageCollectionViewController.imageList.isEmpty else {
            coordinator?.presentBasicAlert(sender: self, message: "이미지는 1장 이상 등록해야 합니다.")
            return
        }

        guard (10...1000).contains(productDescriptionTextView.text.count) else {
            coordinator?.presentBasicAlert(sender: self, message: "상품 설명은 10자 이상, 1000자 이하로 작성해야 합니다.")
            return
        }

        guard !(productNameTextField.text?.isEmpty ?? false),
              !(productPriceTextField.text?.isEmpty ?? false),
              !(productStockTextField.text?.isEmpty ?? false),
              !(productDiscountedPriceTextField.text?.isEmpty ?? false) else {
                  coordinator?.presentBasicAlert(sender: self, message: "모든 항목을 입력해주세요.")
                  return
              }
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

        productNameTextField.text = product.name
        productPriceTextField.text = String(product.price)
        productDiscountedPriceTextField.text = String(product.bargainPrice)
        productDescriptionTextView.text = product.description
        productStockTextField.text = String(product.stock)
        currencySegmentControl.selectedSegmentIndex = product.currency == .KRW ? 0 : 1
        addProductImageCollectionViewController.imageList = images
    }
}
