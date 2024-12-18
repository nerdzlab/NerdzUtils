//
//  UIVIewController+Overlay.swift
//  NerdzUtils
//
//  Created by new user on 12.07.2021.
//

#if canImport(UIKit)

import UIKit

public enum OverlayPresentationError: Error {
    case noWindow
    case notOverlay
    
    var localizedDescription: String {
        switch self {
        case .noWindow:
            return "View controller view do not have window available"
            
        case .notOverlay:
            return "Current view controller was not presented as overlay"
        }
    }
}

public extension NZUtilsExtensionData where Base: UIViewController {
    
    typealias WindowConfiguratoinAction = (UIWindow) -> Void
    
    /// Presenting current view controller as overlay
    func presentAsOverlay(with configurationAction: @escaping WindowConfiguratoinAction = UIViewController.nz.defaultWindowConfiguration) {
        let window = UIWindow()
        window.rootViewController = base
        configurationAction(window)
        window.makeKeyAndVisible()
     
        UIViewController.presentedWindows.append(window)
    }
    
    /// Dismissing current view controller if it was presented as overlay
    /// - Throws: `.noWindow` if view do not have window available, `.notOverlay` if view controller was not presented as overlay
    func dismissOverlay() throws {
        guard let window = base.view.window else {
            throw OverlayPresentationError.noWindow
        }
        
        guard let index = UIViewController.presentedWindows.firstIndex(where: { $0 === window }) else {
            throw OverlayPresentationError.notOverlay
        }
        
        window.resignKey()
        UIViewController.presentedWindows.remove(at: index)
    }
    
    static func defaultWindowConfiguration(_ window: UIWindow) {
        window.windowLevel = .alert
        window.backgroundColor = .clear
    }
}

private extension UIViewController {
    static var presentedWindows: [UIWindow] = []
}

#endif
