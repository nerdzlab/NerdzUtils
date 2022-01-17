//
//  UIViewController+AddChild.swift
//  NerdzUtils
//
//  Created by new user on 12.09.2020.
//

#if canImport(UIKit)

import UIKit

public extension NZUtilsExtensionData where Base: UIViewController {
    
    /// Adding child to controller with all necessary configuration
    /// - Parameters:
    ///   - childController: Controller to add as a child
    ///   - container: Container in with needs to be added. If not provided - `view` will be used
    ///   - configurationAction: Configuration action to setup all constraints. If not provided - will becoe full size of a container
    @available (iOS 9, *)
    func easilyAddChild(
        _ childController: UIViewController,
        on container: UIView? = nil,
        configurationAction: ((UIView, UIView) -> Void) = UIViewController.nz.setupFullscreen
    ) {
        
        let finalContainer: UIView = container ?? base.view
        
        childController.willMove(toParent: base)
        base.addChild(childController)
        finalContainer.addSubview(childController.view)
        childController.view.translatesAutoresizingMaskIntoConstraints = false
        configurationAction(childController.view, finalContainer)
        childController.didMove(toParent: base)
    }

    @available (iOS 9, *)
    static func setupFullscreen(_ childView: UIView, on parentView: UIView) {
        childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        childView.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
    }
}

#endif
