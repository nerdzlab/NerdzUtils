//
//  UIImage+FromView.swift
//  NerdzUtils
//
//  Created by new user on 16.05.2021.
//

import UIKit

extension UIImage {
    
    convenience init(_ view: UIView) {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        
        let image = renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
        
        super.init
    }
}
