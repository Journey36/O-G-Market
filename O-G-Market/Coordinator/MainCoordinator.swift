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
    
    func presentEditActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: "Edit Product", preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "수정하기", style: .default) { _ in
            self.presentEditViewController()
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
    
    func presentPHPickerViewController(sender: UIViewController) {
        var phPickerConfiguration = PHPickerConfiguration()
        phPickerConfiguration.selectionLimit = 5
        
        let imagePickerViewcontroller = PHPickerViewController(configuration: phPickerConfiguration)
        imagePickerViewcontroller.delegate = sender as? PHPickerViewControllerDelegate
        sender.present(imagePickerViewcontroller, animated: true, completion: nil)
    }
}
