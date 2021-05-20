//
//  UIImage+Crop.swift
//  NerdzUtils
//
//  Created by new user on 20.05.2021.
//

import UIKit

extension UIImage {
    func scaled(toWidth value: CGFloat) -> UIImage {
        let scale = value / size.width
        return scaled(by: scale)
    }
    
    func scaled(toHeight value: CGFloat) -> UIImage {
        let scale = value / size.height
        return scaled(by: scale)
    }
    
    func scaled(toBigger value: CGFloat) -> UIImage {
        if size.height > size.width {
            return scaled(toHeight: value)
        }
        else {
            return scaled(toWidth: value)
        }
    }
    
    func scaled(toSmaller value: CGFloat) -> UIImage {
        if size.height > size.width {
            return scaled(toWidth: value)
        }
        else {
            return scaled(toHeight: value)
        }
    }
    
    func scaled(toFit targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func scaled(by scale: CGFloat) -> UIImage? {
        let scaledSize = CGSize(width: size.width * scale, height: size.height * scale)
        return scaled(toFit: scaledSize)
    }
}
