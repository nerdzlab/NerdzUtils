//
//  UIView+ApplyShadow.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 14.01.2022.
//

#if canImport(UIKit)

import UIKit

public extension NZUtilsExtensionData where Base: UIView {
    
    // Add shadow to view
    func applyShadow(
        color: UIColor,
        opacity: Float = 0.5,
        offSet: CGSize = .zero,
        radius: CGFloat = 1
    ) {
        base.layer.shadowColor = color.cgColor
        base.layer.shadowRadius = radius
        base.layer.shadowOpacity = opacity
        base.layer.shadowOffset = offSet
    }
}

#endif
