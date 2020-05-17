import UIKit

extension UINavigationController {
    
    public func pushViewController(_ viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    public func popToViewController(_ viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popToViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    public func popViewController(animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
    
    public func popToRootViewController(animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popToRootViewController(animated: animated)
        CATransaction.commit()
    }
}

