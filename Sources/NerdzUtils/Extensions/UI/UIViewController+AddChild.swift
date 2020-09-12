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
        configurationAction(childController.view, view)
        childController.didMove(toParent: self)
    }
    
    private static func setupFullscreen(_ childView: UIView, on parentView: UIView) {
        let views = ["childView": childView]
        
        let horisontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[childView]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views)
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[childView]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views)

        parentView.addConstraints(horisontalConstraint)
        parentView.addConstraints(verticalConstraint)
    }
}
