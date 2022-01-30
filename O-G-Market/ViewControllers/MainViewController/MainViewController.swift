//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private enum Section: Int, CaseIterable {
        case carousel, list
    }

    // MARK: - Properties
    private var dataSource: UICollectionViewDiffableDataSource<Section, Post>?

    // MARK: - UI Componenets
    private lazy var productCollectionView: UICollectionView = {
        let productCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: configureCollectionViewLayout())
        return productCollectionView
    }()
    private let productRegisterButton: UIButton = {
        let productRegisterButton = UIButton()
        let buttonImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .bold))
        productRegisterButton.setImage(buttonImage, for: .normal)
        productRegisterButton.backgroundColor = .systemBlue
        productRegisterButton.tintColor = .white
        productRegisterButton.layer.cornerRadius = 35
        productRegisterButton.layer.shadowPath = UIBezierPath(rect: productRegisterButton.bounds).cgPath
        productRegisterButton.layer.shouldRasterize = true
        productRegisterButton.layer.rasterizationScale = UIScreen.main.scale
        productRegisterButton.layer.shadowColor = UIColor.systemGray.cgColor
        productRegisterButton.layer.shadowOpacity = 1.0
        productRegisterButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        return productRegisterButton
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "O.G Market"
        productCollectionView.delegate = self
        configureConstraints()
        configureDataSource()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Networking.default.requestGET { result in
            switch result {
            case .success(let data):
                self.initializeSnapshot(with: data)
            case .failure(let error):
                preconditionFailure(error.localizedDescription)
            }
        }
    }

    // MARK: - Methods
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            let section: NSCollectionLayoutSection
            switch sectionKind {
            case .carousel:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.25))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.interGroupSpacing = 20
                section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
                section.contentInsetsReference = .safeArea
            case .list:
                let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            }

            return section
        }

        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }

    private func createGridCellRegistration() -> UICollectionView.CellRegistration<CarouselItem, Post> {
        return UICollectionView.CellRegistration<CarouselItem, Post> { cell, _, product in
            self.fetchImage(from: product.thumbnail, for: cell)
            cell.productNameLabel.text = product.name
            cell.productDiscountedPriceLabel.text = product.discountedPrice.description
            cell.productPriceLabel.text = product.price.description
            cell.productStockLabel.text = product.stock.description
            var background = UIBackgroundConfiguration.listPlainCell()
            background.cornerRadius = 10
            cell.backgroundConfiguration = background
        }
    }

    private func createListCellRegistration() -> UICollectionView.CellRegistration<ListItem, Post> {
        return UICollectionView.CellRegistration<ListItem, Post> { cell, _, product in
            self.fetchImage(from: product.thumbnail, for: cell)
            cell.productNameLabel.text = product.name
            cell.productDiscountedPriceLabel.text = product.discountedPrice.description
            cell.productPriceLabel.text = product.price.description
            cell.productStockLabel.text = product.stock.description
        }
    }

    private func configureDataSource() {
        let gridCellRegistration = createGridCellRegistration()
        let listCellRegistration = createListCellRegistration()

        dataSource = UICollectionViewDiffableDataSource<Section, Post>(collectionView: productCollectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .carousel:
                return collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration, for: indexPath, item: item)
            case .list:
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: item)
            }
        }
    }

    private func initializeSnapshot(with list: ProductList) {
        guard let dataSource = dataSource else { return }

        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, Post>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)

        var carouselItems: [Post] = []
        for index in 1...5 {
            carouselItems.append(list.posts[index])
        }

        var listItems: [Post] = []
        for index in 6...19 {
            listItems.append(list.posts[index])
        }

        var carouselSnapshot = NSDiffableDataSourceSectionSnapshot<Post>()
        carouselSnapshot.append(carouselItems)

        var listSnapshot = NSDiffableDataSourceSectionSnapshot<Post>()
        listSnapshot.append(listItems)

        dataSource.apply(carouselSnapshot, to: .carousel, animatingDifferences: false)
        dataSource.apply(listSnapshot, to: .list, animatingDifferences: false)
    }

    private func configureConstraints() {
        view.addSubview(productCollectionView)
        view.addSubview(productRegisterButton)

        productCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        productRegisterButton.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
}

// MARK: - Extensions
extension MainViewController {
    private func fetchImage(from imageURLString: String, for cell: UICollectionViewCell) {
        let imageLoadQueue = DispatchQueue(label: "com.joruney36.o-g-market")
        imageLoadQueue.async {
            guard let imageURL = URL(string: imageURLString),
                  let imageData = try? Data(contentsOf: imageURL),
                  let image = UIImage(data: imageData) else {
                      return
                  }

            DispatchQueue.main.async {
                switch cell {
                case let cell as CarouselItem:
                    cell.productImageView.image = image
                case let cell as ListItem:
                    cell.productImageView.image = image
                default:
                    #if DEBUG
                    assertionFailure("ADD NEW SECTION CELL")
                    #endif
                    break
                }
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: - 화면 전환
    }
}
