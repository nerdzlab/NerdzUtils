//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation

extension NSObject: NZUtilsExtensionCompatible { }

public extension NZUtilsExtensionData where Base: NSObject {
    /// Current class name
    static var className: String {
        String(describing: Base.self)
    }
    
    /// Current class name
    var className: String {
        String(describing: type(of: base))
    }
}
