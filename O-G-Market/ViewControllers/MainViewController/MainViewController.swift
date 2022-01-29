//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private enum Section: Int, CaseIterable {
        case carousel, list
    }

    // MARK: - Properties
    // FIXME: - 모델 생성 후 변경 `Int` -> `<ModelType>`
    var coordinator: MainCoordinator?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Int>?

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
        initializeSnapshot()
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

    private func createGridCellRegistration() -> UICollectionView.CellRegistration<CarouselItem, Int> {
        return UICollectionView.CellRegistration<CarouselItem, Int> { cell, _, _ in
            cell.productImageView.image = UIImage(systemName: "bolt.car")
            cell.productNameLabel.text = "MacBook Pro 14"
            cell.productDiscountedPriceLabel.text = "3,000,000"
            cell.productPriceLabel.text = "3,500,000"
            cell.productStockLabel.text = "품절"
            var background = UIBackgroundConfiguration.listPlainCell()
            background.cornerRadius = 10
            cell.backgroundConfiguration = background
        }
    }

    private func createListCellRegistration() -> UICollectionView.CellRegistration<ListItem, Int> {
        return UICollectionView.CellRegistration<ListItem, Int> { cell, _, _ in
            cell.productImageView.image = UIImage(systemName: "bolt.car")
            cell.productNameLabel.text = "MacBook Pro 14"
            cell.productDiscountedPriceLabel.text = "3,000,000"
            cell.productPriceLabel.text = "3,500,000"
            cell.productStockLabel.text = "품절"
        }
    }

    private func configureDataSource() {
        let gridCellRegistration = createGridCellRegistration()
        let listCellRegistration = createListCellRegistration()

        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: productCollectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .carousel:
                return collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration, for: indexPath, item: item)
            case .list:
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: item)
            }
        }
    }

    private func initializeSnapshot() {
        guard let dataSource = dataSource else { return }

        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)

        var carouselItems: [Int] = []
        for index in 1...10 {
            carouselItems.append(index)
        }

        var carouselSnapshot = NSDiffableDataSourceSectionSnapshot<Int>()
        carouselSnapshot.append(carouselItems)

        var allSnapshot = NSDiffableDataSourceSectionSnapshot<Int>()
        var listItems: [Int] = []
        for index in 11...30 {
            listItems.append(index)
        }

        allSnapshot.append(listItems)

        dataSource.apply(carouselSnapshot, to: .carousel, animatingDifferences: false)
        dataSource.apply(allSnapshot, to: .list, animatingDifferences: false)
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
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.pushDetailViewController()
    }
}
