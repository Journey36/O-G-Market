//
//  MainCoordinator.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/27.
//

import UIKit
import PhotosUI

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
    
    func pushDetailViewController(productId: Int) {
        let viewController = DetailViewController()
        viewController.coordinator = self
        viewController.productImagePageViewController.coordinator = self
        
        Networking.default.requestGET(with: productId) { result in
            switch result {
            case .success(let product):
                DispatchQueue.main.async {
                    viewController.setUpComponentsData(product: product)
                }
            case .failure(let error):
                self.dismissModal(sender: viewController)
                return
            }
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func presentRegistViewController() {
        let viewController = ProductEditViewController(type: .regist)
        let newNavigationController = UINavigationController(rootViewController: viewController)
        viewController.coordinator = self
        viewController.addProductImageCollectionViewController.coordinator = self
        newNavigationController.modalPresentationStyle = .overFullScreen
        navigationController.topViewController?.present(newNavigationController, animated: true, completion: nil)
    }
    
    func presentEditViewController(product: ProductDetails?, images: [UIImage]) {
        let viewController = ProductEditViewController(type: .edit)
        let newNavigationController = UINavigationController(rootViewController: viewController)
        viewController.coordinator = self
        viewController.addProductImageCollectionViewController.coordinator = self
        viewController.setUpComponentsData(product: product, images: images)
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
    
    func presentEditActionSheet(product: ProductDetails?, images: [UIImage]) {
        let actionSheet = UIAlertController(title: nil, message: "Edit Product", preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "수정하기", style: .default) { _ in
            self.presentEditViewController(product: product, images: images)
        }
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
            self.presentDeleteAlert()
        }
        let cancelAction = UIAlertAction(title: "취소하기", style: .cancel, handler: nil)
    
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        navigationController.topViewController?.present(actionSheet, animated: true, completion: nil)
    }
    
    func presentDeleteAlert() {
        // 임시 코드
        let sample = ProductDeletion(productID: 19, productSecret: "19")
        let alert = ProductDeleteAlertController(productDeletionInfo: sample)
        self.navigationController.topViewController?.present(alert, animated: true, completion: nil)
    }
    
    func presentActivityViewController(sender: UIViewController) {
        let activityViewController = UIActivityViewController(activityItems: ["오동나무"], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.barButtonItem = sender.navigationItem.rightBarButtonItems?.first
        navigationController.topViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    func presentPHPickerViewController(sender: UIViewController, selectionLimit: Int) {
        var phPickerConfiguration = PHPickerConfiguration()
        phPickerConfiguration.selectionLimit = selectionLimit
        
        let imagePickerViewcontroller = PHPickerViewController(configuration: phPickerConfiguration)
        imagePickerViewcontroller.delegate = sender as? PHPickerViewControllerDelegate
        sender.present(imagePickerViewcontroller, animated: true, completion: nil)
    }
    
    func dismissModal(sender: UIViewController) {
        sender.dismiss(animated: true, completion: nil)
    }
    
    func presentBasicAlert(sender: UIViewController, message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        sender.present(alert, animated: true, completion: nil)
    }
}
