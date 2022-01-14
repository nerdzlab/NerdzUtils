//
//  UIView+AddDashedBorder.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 14.01.2022.
//

#if canImport(UIKit)

import UIKit

public extension NZExtensionData where Base: UIView {
    // Add dashed border to view
    @discardableResult
    func addDashedBorder(
        with strokeColor: UIColor,
        fillColor: UIColor = UIColor.clear,
        position: CGPoint = .zero,
        lineWidth: CGFloat = 2,
        lineJoin: CAShapeLayerLineJoin = .round,
        lineDashPattern: [NSNumber] = [6, 3],
        cornerRadius: CGFloat = 20
    ) -> CAShapeLayer {
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        
        shapeLayer.bounds = base.bounds
        shapeLayer.position = position
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = lineJoin
        shapeLayer.lineDashPattern = lineDashPattern
        shapeLayer.path = UIBezierPath(roundedRect: base.bounds, cornerRadius: cornerRadius).cgPath
        
        base.layer.addSublayer(shapeLayer)
        return shapeLayer
    }
}

#endif
