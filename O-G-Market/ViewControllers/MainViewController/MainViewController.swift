//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    private enum Section {
        case main
    }

    // MARK: - Properties
    var coordinator: MainCoordinator?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Post>?

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
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }

    private func createListCellRegistration() -> UICollectionView.CellRegistration<ProductCell, Post> {
        return UICollectionView.CellRegistration<ProductCell, Post> { cell, _, product in
            cell.setUpComponentsData(of: product)
        }
    }

    private func configureDataSource() {
        let cellRegistration = createListCellRegistration()

        dataSource = UICollectionViewDiffableDataSource<Section, Post>(collectionView: productCollectionView) { collectionView, indexPath, id -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: id)
        }
    }

    private func initializeSnapshot(with list: ProductList) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Post>()
        snapshot.appendSections([.main])
        var listItems: [Post] = []
        for index in 0..<list.itemsPerPage {
            listItems.append(list.posts[index])
        }
        snapshot.appendItems(listItems)
        dataSource?.apply(snapshot, animatingDifferences: false)
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

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        coordinator?.pushDetailViewController()
    }
}
