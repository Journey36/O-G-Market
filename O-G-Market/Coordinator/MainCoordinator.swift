//
//  MainCoordinator.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/27.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinator = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let initialViewController = MainViewController()
        initialViewController.coordinator = self
        navigationController.pushViewController(initialViewController, animated: true)
    }
    
    func pushDetailViewController() {
        let viewController = DetailViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
        viewController.productImagePageViewController.coordinator = self
    }
    
    func presentEditViewController() {
        let viewController = ProductEditViewController(type: .regist)
        let newNavigationController = UINavigationController(rootViewController: viewController)
        viewController.coordinator = self
        viewController.addProductImageCollectionViewController.coordinator = self
        newNavigationController.modalPresentationStyle = .overFullScreen
        navigationController.topViewController?.present(newNavigationController, animated: true, completion: nil)
    }
    
    func presentImageViewerController(sender: UIViewController, images: [UIImage]?) {
        let viewController = ImageViewerController()
        viewController.images = images
        viewController.coordinator = self
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        sender.present(viewController, animated: true, completion: nil)
    }
}
