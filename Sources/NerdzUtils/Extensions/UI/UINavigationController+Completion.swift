
#if canImport(UIKit)

import UIKit

extension UINavigationController {
    
    /// Pushing view controller view completion
    /// - Parameters:
    ///   - viewController: Pushing controller
    ///   - animated: If needs to be animated
    ///   - completion: Completion
    public func pushViewController(_ viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    /// Popping to view controller view completion
    /// - Parameters:
    ///   - viewController: Pushing controller
    ///   - animated: If needs to be animated
    ///   - completion: Completion
    public func popToViewController(_ viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popToViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    /// Popping view controller view completion
    /// - Parameters:
    ///   - viewController: Pushing controller
    ///   - animated: If needs to be animated
    ///   - completion: Completion
    public func popViewController(animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
    
    /// Popping to root view controller view completion
    /// - Parameters:
    ///   - viewController: Pushing controller
    ///   - animated: If needs to be animated
    ///   - completion: Completion
    public func popToRootViewController(animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popToRootViewController(animated: animated)
        CATransaction.commit()
    }
}

#endif
