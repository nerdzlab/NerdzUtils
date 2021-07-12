//
//  UIApplication+TopViewController.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 12.07.2021.
//

#if canImport(UIKit)

import UIKit

extension UIApplication {

    class func topViewController(
        controller: UIViewController? = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
    ) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController,
           let selected = tabController.selectedViewController {
            return topViewController(controller: selected)
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
    
}

#endif
