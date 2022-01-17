//
//  SpinnerLoader.swift
//  NerdzUtils
//
//  Created by new user on 08.11.2020.
//

#if canImport(UIKit)

import UIKit

@available(iOS 9.0, *)
public class SpinnerLoader {
    fileprivate static var loaders: [SpinnerLoader] = []

    fileprivate let view: UIView
    
    private var restorationAction: (() -> Void)?

    private lazy var indicator: UIActivityIndicatorView = {
        UIActivityIndicatorView(style: .whiteLarge)
    }()
    
    fileprivate init(view: UIView) {
        self.view = view
    }

    func startLoading(withColor spinnerColor: UIColor? = nil, size: CGFloat? = nil) {
        view.addSubview(indicator)
        
        let size = size ?? min(view.bounds.width, view.bounds.height) * 0.8
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: size).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: size).isActive = true

        indicator.color = spinnerColor ?? view.backgroundColor?.nz.inversed

        if let button = view as? UIButton {
            let title = button.titleLabel?.text
            let image = button.imageView?.image
            button.isUserInteractionEnabled = false

            restorationAction = { [weak button] in
                button?.setTitle(title, for: .normal)
                button?.setImage(image, for: .normal)
                button?.isUserInteractionEnabled = true
            }

            button.setTitle(nil, for: .normal)
            button.setImage(nil, for: .normal)

            if let color = button.titleColor(for: .normal) {
                indicator.color = color
            }
        }

        type(of: self).loaders.append(self)
        indicator.startAnimating()
    }

    func stopLoading() {
        type(of: self).loaders.removeAll(where: { $0 === self })
        indicator.stopAnimating()
        restorationAction?()
        indicator.removeFromSuperview()
    }
}

@available(iOS 9.0, *)
public extension UIView {
    
    /// Starts loading with spinner
    /// - Parameters:
    ///   - color: Loader color
    ///   - size: Loader size
    func startSpinnerLoading(with color: UIColor? = nil, size: CGFloat? = nil) {
        let loader = SpinnerLoader(view: self)
        loader.startLoading(withColor: color, size: size)
    }
    
    /// Stops loading
    func stopSpinnerLoading() {
        guard let loader = SpinnerLoader.loaders.first(where: { $0.view === self }) else {
            return
        }
        
        loader.stopLoading()
    }
}

#endif
