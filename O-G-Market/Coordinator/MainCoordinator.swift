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
    }
    
    func presentEditViewController() {
        let viewController = ProductEditViewController()
        let newNavigationController = UINavigationController(rootViewController: viewController)
        viewController.coordinator = self
        newNavigationController.modalPresentationStyle = .overFullScreen
        navigationController.present(newNavigationController, animated: true, completion: nil)
    }
}
