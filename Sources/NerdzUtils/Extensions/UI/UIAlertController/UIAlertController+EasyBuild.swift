//
//  File.swift
//  
//
//  Created by new user on 29.04.2020.
//

#if canImport(UIKit)

import UIKit

public extension NZUTilsExtensionData where Base: UIAlertController {
    typealias ActionHandler = () -> Void
    
    /// Adding default action to alert
    /// - Parameters:
    ///   - title: Action title
    ///   - handler: Action handler
    /// - Returns: Same alert for future configuration
    @discardableResult
    func action(title: String?, handler: ActionHandler? = nil) -> UIAlertController {
        return addButton(withStyle: .default, title: title, handler: handler)
    }
    
    /// Adding desctructive action to alert
    /// - Parameters:
    ///   - title: Action title
    ///   - handler: Action handler
    /// - Returns: Same alert for future configuration
    @discardableResult
    func destructive(title: String?, handler: ActionHandler? = nil) -> UIAlertController {
        return addButton(withStyle: .destructive, title: title, handler: handler)
    }
    
    /// Adding cancel action to alert
    /// - Parameters:
    ///   - title: Action title
    ///   - handler: Action handler
    /// - Returns: Same alert for future configuration
    @discardableResult
    func cancel(title: String?, handler: ActionHandler? = nil) -> UIAlertController {
        return addButton(withStyle: .cancel, title: title, handler: handler)
    }
    
    /// Setting up controller source view for tablets
    /// - Parameter source: Source view
    /// - Returns: Same alert for future configuration
    @discardableResult
    func source(_ source: UIView) -> UIAlertController {
        base.popoverPresentationController?.sourceView = source
        base.popoverPresentationController?.sourceRect = source.bounds
        
        return base
    }
    
    /// Presenting on controller
    /// - Parameter controller: Presenting controller
    /// - Returns: Return `true` if presentation might be successful
    @discardableResult
    func show(on controller: UIViewController) -> Bool {
        if validateBulider() {
            controller.present(base, animated: true)
            return true
        }
        else {
            return false
        }
    }
    
    private func validateBulider() -> Bool {
        return validateActionsNumber() && validateContent() && validatePopoverSource()
    }
    
    private func validatePopoverSource() -> Bool {
        if base.preferredStyle == .alert {
            return true
        }
        
        let sourceValid = base.preferredStyle == .actionSheet &&
        base.popoverPresentationController?.sourceView != nil &&
        base.popoverPresentationController?.sourceRect != nil
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        
        if !sourceValid {
            return !isPad
        }
        
        return true
    }
    
    private func validateActionsNumber() -> Bool {
        if base.preferredStyle == .alert && base.actions.isEmpty {
            return false
        }
        
        return true
    }
    
    private func validateContent() -> Bool  {
        if base.title == nil && base.message == nil && base.preferredStyle == .alert {
            return false
        }
        
        
        return true
    }
    
    private func addButton(withStyle style: UIAlertAction.Style, title: String?, handler: ActionHandler?) -> UIAlertController {
        let action = UIAlertAction(title: title, style: style) { _ in
            handler?()
        }
        
        base.addAction(action)
        return base
    }
}

public extension UIAlertController {
    
    @objc
    func assignPopoverDirectionBasedUponGivenView(
        sourcePosition: CGPoint,
        sourceSize: CGSize,
        screenSize: CGSize = UIScreen.main.bounds.size,
        alertSize: CGSize = CGSize(width: 270.0, height: 144.0)
    ) -> UIPopoverArrowDirection {
        var direction: UIPopoverArrowDirection
        let profileX = sourcePosition.x
        let profileY = sourcePosition.y
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        let profileHeight = sourceSize.height
        let profileWidth = sourceSize.width
        let alertHeight = alertSize.height
        let alertWidth = alertSize.width
        
        if alertWidth/2 > (profileX + profileWidth/2) {
            direction = UIPopoverArrowDirection.left
        }
        else if screenWidth < (profileX + profileWidth/2 + alertWidth/2) {
            direction = UIPopoverArrowDirection.right
        }
        else if screenHeight < (profileY + profileHeight + alertHeight) {
            direction = UIPopoverArrowDirection.down
        }
        else {
            direction = UIPopoverArrowDirection.up
        }
        
        popoverPresentationController?.permittedArrowDirections = direction
        
        return direction
    }
    
    @discardableResult
    @objc
    func assignPopoverDirection(sourcePosition: CGPoint, sourceSize: CGSize) -> UIPopoverArrowDirection {
        return self.assignPopoverDirectionBasedUponGivenView(
            sourcePosition: sourcePosition,
            sourceSize: sourceSize
        )
    }
}

#endif
