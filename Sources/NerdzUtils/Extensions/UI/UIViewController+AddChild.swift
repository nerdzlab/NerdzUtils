//
//  UIViewController+AddChild.swift
//  NerdzUtils
//
//  Created by new user on 12.09.2020.
//

import UIKit

public extension UIViewController {
    
    @available (iOS 9, *)
    func easilyAddChild(_ childController: UIViewController, on container: UIView? = nil, configurationAction: ((UIView, UIView) -> Void) = UIViewController.setupFullscreen) {
        
        let finalContainer: UIView = container ?? view
        
        childController.willMove(toParent: self)
        addChild(childController)
        finalContainer.addSubview(childController.view)
        childController.view.translatesAutoresizingMaskIntoConstraints = false
        configurationAction(childController.view, finalContainer)
        childController.didMove(toParent: self)
    }
    
    @available (iOS 9, *)
    static func setupFullscreen(_ childView: UIView, on parentView: UIView) {
        
        childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        childView.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
    }
}
