//
//  Coordinator.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/01/27.
//

import UIKit

protocol Coordinator {
    var childCoordinator: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
}
