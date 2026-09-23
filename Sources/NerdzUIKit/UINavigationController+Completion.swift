#if os(iOS)

import UIKit
import NerdzCore

@MainActor
public extension NZExtensionData where Base: UINavigationController {

    /// Pushing view controller view completion
    /// - Parameters:
    ///   - viewController: Pushing controller
    ///   - animated: If needs to be animated
    ///   - completion: Completion
    func pushViewController(_ viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        base.pushViewController(viewController, animated: animated)
        base.runAfterNavigationTransition(animated: animated, completion: completion)
    }

    /// Popping to view controller view completion
    /// - Parameters:
    ///   - viewController: Pushing controller
    ///   - animated: If needs to be animated
    ///   - completion: Completion
    func popToViewController(_ viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        base.popToViewController(viewController, animated: animated)
        base.runAfterNavigationTransition(animated: animated, completion: completion)
    }

    /// Popping view controller view completion
    /// - Parameters:
    ///   - viewController: Pushing controller
    ///   - animated: If needs to be animated
    ///   - completion: Completion
    func popViewController(animated: Bool, completion: (() -> Void)?) {
        base.popViewController(animated: animated)
        base.runAfterNavigationTransition(animated: animated, completion: completion)
    }

    /// Popping to root view controller view completion
    /// - Parameters:
    ///   - viewController: Pushing controller
    ///   - animated: If needs to be animated
    ///   - completion: Completion
    func popToRootViewController(animated: Bool, completion: (() -> Void)?) {
        base.popToRootViewController(animated: animated)
        base.runAfterNavigationTransition(animated: animated, completion: completion)
    }
}

private extension UINavigationController {

    /// Runs `completion` when the current navigation transition finishes.
    ///
    /// Uses the navigation controller's transition coordinator instead of
    /// `CATransaction.setCompletionBlock`. A `UINavigationController` push/pop animation is driven by
    /// its own transition coordinator, not by the surrounding `CATransaction`, so the transaction
    /// completion block is not reliably tied to the transition and can silently never fire, leaving
    /// the caller's completion unexecuted. When there is no active transition (e.g. `animated == false`
    /// or the stack did not change) the completion runs immediately, matching the previous behavior for
    /// the non-animated case, so callers never hang.
    func runAfterNavigationTransition(animated: Bool, completion: (() -> Void)?) {
        guard let completion else {
            return
        }

        if animated, let transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        }
        else {
            completion()
        }
    }
}

#endif
