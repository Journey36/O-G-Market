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
    private var collectionViewLayout: UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }

    private let startPage = 1
    private lazy var currentPage = startPage
    private var fetchingIndexPathRow = 18

    // MARK: - UI Componenets
    private lazy var productCollectionView: UICollectionView = {
        let productCollectionView = UICollectionView(frame: view.bounds,
                                                     collectionViewLayout: collectionViewLayout)

        productCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)

        return productCollectionView
    }()
    private lazy var productRegisterButton: UIButton = {
        let button = ProductRegisterButton(frame: CGRect.zero)
        button.addTarget(self, action: #selector(presentProductRegisterViewController),
                         for: .touchUpInside)
        return button
    }()
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
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

    private func initializeSnapshot(with list: Page) {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(list.post)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func changeSnapshot(with list: Page) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(list.post)
        dataSource.apply(snapshot, animatingDifferences: false)
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

    @objc private func refreshCollectionView() {
        Task {
            guard let page = try? await manager.fetch(pages: startPage) else { return }
            var snapshot = dataSource.snapshot()
            snapshot.deleteAllItems()
            snapshot.appendSections([.main])
            snapshot.appendItems(page.post)
            await dataSource.applySnapshotUsingReloadData(snapshot)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshControl.endRefreshing()
        }

        fetchingIndexPathRow = 18
    }

    private func fetchList() {
        Task {
            guard let page = try? await manager.fetch(pages: startPage) else { return }
            initializeSnapshot(with: page)
        }
    }

    private func appendToList() {
        Task {
            guard let page = try? await manager.fetch(pages: currentPage + 1) else { return }
            changeSnapshot(with: page)
            guard !page.hasNextPage else {
                currentPage += 1
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
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths where indexPath.row == fetchingIndexPathRow {
            appendToList()
        }
    }
}
