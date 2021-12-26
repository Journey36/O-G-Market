//
//  DetailViewController.swift
//  O-G-Market
//

import Foundation
import UIKit
import SnapKit
import SwiftUI

class DetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
}



// Preview
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = DetailViewController

    func makeUIViewController(context: Context) -> DetailViewController {
        return DetailViewController()
    }

    func updateUIViewController(_ uiViewController: DetailViewController, context: Context) {

    }
}

@available(iOS 13.0.0, *)
struct ViewPreview: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
    
    struct Container: UIViewControllerRepresentable {
        typealias UIViewControllerType = UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            UINavigationController(rootViewController: DetailViewController())
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
