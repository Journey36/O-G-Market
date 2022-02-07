//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private enum Section {
        case main
    }

    // MARK: - Properties
    var coordinator: MainCoordinator?
    private var dataSource: UICollectionViewDiffableDataSource<Section, ListProduct>?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, ListProduct>()
    private var currentPage: Int = 1
    private var fetchingIndexPathRow = 18

    // MARK: - UI Componenets
    private lazy var productCollectionView: UICollectionView = {
        let productCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: configureCollectionViewLayout())
        return productCollectionView
    }()
    private lazy var productRegisterButton: UIButton = ProductRegisterButton(coordinator: coordinator)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "O.G Market"
        productCollectionView.delegate = self
        productCollectionView.prefetchDataSource = self
        configureConstraints()
        configureDiffableDataSource()
        fetchList()
    }

    // MARK: - Methods
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }

    private func configureProductCell() -> UICollectionView.CellRegistration<ProductCell, ListProduct> {
        return UICollectionView.CellRegistration<ProductCell, ListProduct> { cell, _, product in
            self.fetchImage(from: product.thumbnail, for: cell)
            cell.productNameLabel.text = product.name
            cell.productDiscountedPriceLabel.text = product.discountedPrice.description
            cell.productPriceLabel.text = product.price.description
            cell.productStockLabel.text = product.stock.description
        }
    }

    private func configureDiffableDataSource() {
        let productCell = configureProductCell()

        dataSource = UICollectionViewDiffableDataSource<Section, ListProduct>(collectionView: productCollectionView) { collectionView, indexPath, id -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: productCell, for: indexPath, item: id)
        }
    }

    private func takeInitialSnapshot(with list: Pages) {
        snapshot.appendSections([.main])
        snapshot.appendItems(list.items)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    private func takeOtherSnapshot(with list: Pages) {
        snapshot.appendItems(list.items)
        dataSource?.apply(snapshot, animatingDifferences: true)
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
    private func fetchImage(from imageURLString: String, for cell: ProductCell) {
        let imageLoadQueue = DispatchQueue(label: "com.joruney36.o-g-market")
        imageLoadQueue.async {
            guard let imageURL = URL(string: imageURLString),
                  let imageData = try? Data(contentsOf: imageURL),
                  let image = UIImage(data: imageData) else {
                      return
                  }

            DispatchQueue.main.async {
                cell.productImageView.image = image
            }
        }
    }

    private func fetchList() {
        Networking.default.requestGET(on: currentPage) { result in
            switch result {
            case .success(let data):
                self.currentPage == 1 ? self.takeInitialSnapshot(with: data) : self.takeOtherSnapshot(with: data)
                guard !data.hasNextPage else {
                    self.currentPage += 1
                    return
                }
            case .failure(let error):
                preconditionFailure(error.localizedDescription)
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        coordinator?.pushDetailViewController()
    }
}

extension MainViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths where indexPath.row == fetchingIndexPathRow {
            fetchList()
            fetchingIndexPathRow += 20
        }
    }
}
