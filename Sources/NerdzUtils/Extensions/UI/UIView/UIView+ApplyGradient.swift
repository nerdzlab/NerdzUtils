//
//  UIView+ApplyGradient.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 14.01.2022.
//

#if canImport(UIKit)

import UIKit

public extension NZUTilsExtensionData where Base: UIView {
    // Add gradient to view
    @available(iOS 11.0, macOS 10.12, *)
    @discardableResult
    func applyGradient(
        colors: [UIColor],
        locations: [NSNumber],
        type: CAGradientLayerType = .axial,
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1)
    ) -> CAGradientLayer {
        
        assert(colors.count >= 2, "Colors must be at least 2.")
        assert(colors.count == locations.count, "Locations must have the same size of color array.")
        
        let gradient = CAGradientLayer()
        gradient.type = type
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        gradient.frame = base.bounds
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        
        base.layer.insertSublayer(gradient, at: 0)
        
        return gradient
    }
}

#endif
