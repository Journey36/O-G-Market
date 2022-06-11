//

import UIKit
import SnapKit
import Alamofire

final class MainViewController: UIViewController {
    private enum Section {
        case main
    }

    // MARK: - Properties
    private let manager = NetworkManager()
    var coordinator: MainCoordinator?

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Post> = {
        let productCell = configureProductCell()
        let cellProvider: UICollectionViewDiffableDataSource<Section, Post>.CellProvider = { collectionView, indexPath, id -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: productCell,
                                                         for: indexPath, item: id)
        }
        let dataSource = UICollectionViewDiffableDataSource<Section, Post>(collectionView: productCollectionView, cellProvider: cellProvider)
        return dataSource
    }()
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Post>()
    private var collectionViewLayout: UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }

    private var startPage: Int = 1
    private var fetchingIndexPathRow = 18

    // MARK: - UI Componenets
    private lazy var productCollectionView: UICollectionView = {
        let productCollectionView = UICollectionView(frame: view.bounds,
                                                     collectionViewLayout: collectionViewLayout)
        return productCollectionView
    }()
    private lazy var productRegisterButton: UIButton = {
        let button = ProductRegisterButton(frame: CGRect.zero)
        button.addTarget(self, action: #selector(presentProductRegisterViewController),
                         for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "O.G Market"
        productCollectionView.delegate = self
        productCollectionView.prefetchDataSource = self
        configureConstraints()
        fetchList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Methods
    private func configureProductCell() -> UICollectionView.CellRegistration<ProductCell, Post> {
        return UICollectionView.CellRegistration<ProductCell, Post> { cell, _, post in
            cell.composeCell(cell, with: post)
        }
    }

    private func takeInitialSnapshot(with list: Page) {
        snapshot.appendSections([.main])
        snapshot.appendItems(list.post)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func takeOtherSnapshot(with list: Page) {
        snapshot.appendItems(list.post)
        dataSource.apply(snapshot, animatingDifferences: true)
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

    @objc private func presentProductRegisterViewController() {
        coordinator?.presentRegistViewController()
    }

    private func fetchList() {
        Task {
            guard let page = try? await manager.fetch(pages: startPage) else { return }
            takeInitialSnapshot(with: page)
        }
    }

    private func appendList() {
        Task {
            guard let page = try? await manager.fetch(pages: startPage + 1) else { return }
            takeOtherSnapshot(with: page)
            guard !page.hasNextPage else {
                startPage += 1
                return
            }
        }

        fetchingIndexPathRow += 20
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let productID = (productCollectionView.cellForItem(at: indexPath) as? ProductCell)?.productID else {
            return
        }
        collectionView.deselectItem(at: indexPath, animated: true)

        coordinator?.pushDetailViewController(productID: productID)
    }
}

extension MainViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths where indexPath.row == fetchingIndexPathRow {
            appendList()
        }
    }
}
