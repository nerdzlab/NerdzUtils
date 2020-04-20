//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import UIKit

public extension UIViewController {
    var topController: UIViewController {
        return topViewController(from: self) ?? self
    }
    
    fileprivate func topViewController(from rootViewController: UIViewController?) -> UIViewController? {
        if let presentedVC = rootViewController?.presentedViewController {
            return topViewController(from: presentedVC)
        }
        else if let navigationVC = rootViewController as? UINavigationController {
            return topViewController(from: navigationVC.topViewController)
        }
        else if let childVC = rootViewController?.children.first {
            return topViewController(from: childVC)
        }
        else {
            return rootViewController
        }
    }
}
