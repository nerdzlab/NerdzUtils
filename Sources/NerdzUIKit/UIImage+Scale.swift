//
//  UIImage+Crop.swift
//  NerdzUtils
//
//  Created by new user on 20.05.2021.
//

#if canImport(UIKit)

import UIKit

public extension NZExtensionData where Base: UIImage {
    /// Scale image to specific width
    /// - Parameter value: Expected width
    /// - Returns: Result image
    func scaled(toWidth value: CGFloat) -> UIImage {
        let scale = value / base.size.width
        return scaled(by: scale)
    }
    
    /// Scale image to specific height
    /// - Parameter value: Expected height
    /// - Returns: Result image
    func scaled(toHeight value: CGFloat) -> UIImage {
        let scale = value / base.size.height
        return scaled(by: scale)
    }
    
    /// Scale image to bigger from width and height
    /// - Parameter value: Expected bigger side
    /// - Returns: Result image
    func scaled(toBigger value: CGFloat) -> UIImage {
        if base.size.height > base.size.width {
            return scaled(toHeight: value)
        }
        else {
            return scaled(toWidth: value)
        }
    }
    
    /// Scale image to smaller from width and height
    /// - Parameter value: Expected smaller side
    /// - Returns: Result image
    func scaled(toSmaller value: CGFloat) -> UIImage {
        if base.size.height > base.size.width {
            return scaled(toWidth: value)
        }
        else {
            return scaled(toHeight: value)
        }
    }
    
    /// Scale image to fit size for width and height
    /// - Parameter targetSize: Expected size to fit
    /// - Returns: Result image
    func scaled(toFit targetSize: CGSize) -> UIImage {
        let widthRatio  = targetSize.width  / base.size.width
        let heightRatio = targetSize.height / base.size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: base.size.width * heightRatio, height: base.size.height * heightRatio)
        } else {
            newSize = CGSize(width: base.size.width * widthRatio,  height: base.size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        base.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? base
    }
    
    /// Scale image by provided factor
    /// - Parameter scale: Scale factor
    /// - Returns: Result image
    func scaled(by scale: CGFloat) -> UIImage {
        let scaledSize = CGSize(width: base.size.width * scale, height: base.size.height * scale)
        return scaled(toFit: scaledSize)
    }
}

#endif
