
#if canImport(UIKit)

import UIKit

public extension NZUtilsExtensionData where Base: UINavigationController {
    
    /// Pushing view controller view completion
    /// - Parameters:
    ///   - viewController: Pushing controller
    ///   - animated: If needs to be animated
    ///   - completion: Completion
    func pushViewController(_ viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        base.pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    /// Popping to view controller view completion
    /// - Parameters:
    ///   - viewController: Pushing controller
    ///   - animated: If needs to be animated
    ///   - completion: Completion
    func popToViewController(_ viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        base.popToViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    /// Popping view controller view completion
    /// - Parameters:
    ///   - viewController: Pushing controller
    ///   - animated: If needs to be animated
    ///   - completion: Completion
    func popViewController(animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        base.popViewController(animated: animated)
        CATransaction.commit()
    }
    
    /// Popping to root view controller view completion
    /// - Parameters:
    ///   - viewController: Pushing controller
    ///   - animated: If needs to be animated
    ///   - completion: Completion
    func popToRootViewController(animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        base.popToRootViewController(animated: animated)
        CATransaction.commit()
    }
}

#endif
