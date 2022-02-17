//
//  UIView+AsImage.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 17.02.2022.
//

#if canImport(UIKit)

import UIKit

public extension NZUtilsExtensionData where Base: UIView {
    
    // Method to get screenshot of view
    // This method will work only for views that added to superview and not hidden
    @available(iOS 11.0, macOS 10.12, *)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: base.bounds)
        return renderer.image { [weak base] _ in
            guard let base = base else {
                return
            }
            
            base.drawHierarchy(in: base.bounds, afterScreenUpdates: true)
        }
    }
}

#endif
