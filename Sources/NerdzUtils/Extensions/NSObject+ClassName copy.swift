//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation

public extension NSObject {
    static var className: String {
        String(describing: self)
    }
    
    var className: String {
        String(describing: type(of: self))
    }
}
