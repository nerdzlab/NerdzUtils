//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

#if canImport(UIKit)

import UIKit

public extension NZUtilsExtensionData where Base: UINavigationBar {
    
    /// Change navigation bar translucent state
    /// - Parameter isTranslucent: Specify if bar needs to be translucent
    func makeTranslucent(_ isTranslucent: Bool) {
        base.setBackgroundImage(UIImage(), for: .default)
        base.shadowImage = UIImage()
        base.isTranslucent = isTranslucent
    }
}

#endif
