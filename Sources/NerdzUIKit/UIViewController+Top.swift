//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

#if canImport(UIKit)

import UIKit

public extension NZExtensionData where Base: UIViewController {
    
    /// Top presented or pushed view controller
    var topController: UIViewController {
        return topViewController(from: base) ?? base
    }
    
    private func topViewController(from rootViewController: UIViewController?) -> UIViewController? {
        if let presentedVC = rootViewController?.presentedViewController {
            return topViewController(from: presentedVC)
        }
        else if let navigationVC = rootViewController as? UINavigationController {
            return topViewController(from: navigationVC.visibleViewController)
        }
        else if let tabController = rootViewController as? UITabBarController,
                let selected = tabController.selectedViewController {
            return topViewController(from: selected)
        }
        else if let childVC = rootViewController?.children.first {
            return topViewController(from: childVC)
        }
        else {
            return rootViewController
        }
    }
}

#endif
