//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation

public extension NSObject {
    /// Current class name
    static var className: String {
        String(describing: self)
    }
    
    /// Current class name
    var className: String {
        String(describing: type(of: self))
    }
}
