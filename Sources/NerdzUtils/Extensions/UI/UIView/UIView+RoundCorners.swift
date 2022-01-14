//
//  UIView+RoundCorners.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 14.01.2022.
//

#if canImport(UIKit)

import UIKit

extension NZExtensionData where Base: UIView {
    
    // Apply round corner and add border. An extension method of UIView.
    @available(iOS 11.0, macOS 10.12, *)
    func roundCorners(
        _ corners: CACornerMask,
        radius: CGFloat,
        borderColor: UIColor = .clear,
        borderWidth: CGFloat = 0
    ) {
        base.layer.cornerRadius = radius
        base.layer.maskedCorners = corners
        base.layer.borderColor = borderColor.cgColor
        base.layer.borderWidth = borderWidth
    }
}

#endif

