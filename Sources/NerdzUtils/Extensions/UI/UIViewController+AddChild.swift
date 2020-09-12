//
//  UIViewController+AddChild.swift
//  NerdzUtils
//
//  Created by new user on 12.09.2020.
//

import UIKit

extension UIViewController {
    
    func addChild(_ childController: UIViewController, configurationAction: ((UIView, UIView) -> Void) = UIViewController.setupFullscreen) {
        
        childController.willMove(toParent: self)
        view.addSubview(childController.view)
        configurationAction()
        childController.didMove(toParent: self)
    }
    
    private static func setupFullscreen(_ childView: UIView, on parentView: UIView) {
        childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        childView.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
    }
}
