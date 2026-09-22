//
//  DateComponents+EasyUse.swift
//  NerdzDate
//
//  Created by new user on 07.10.2020.
//

import Foundation
import NerdzCore

public extension DateComponents {
    subscript(_ component: Calendar.Component) -> Int? {
        get {
            value(for: component)
        }
        
        set {
            setValue(newValue, for: component)
        }
    }
}
