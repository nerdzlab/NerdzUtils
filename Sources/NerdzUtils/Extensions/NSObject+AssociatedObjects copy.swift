//
//  NSObject+AssociatedObjects.swift
//  NerdzUtils
//
//  Created by new user on 13.09.2020.
//

import Foundation
import ObjectiveC

private var PrimaryAssociationId: Int = 0
private var SecondaryAssociationId: Int = 0

public extension NSObject {
    
    var primaryAssociatedObject: Any? {
        get {
            objc_getAssociatedObject(self, &PrimaryAssociationId)
        }
        set {
            objc_setAssociatedObject(self, &PrimaryAssociationId, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var secondaryAssociatedObject: Any? {
        get {
            objc_getAssociatedObject(self, &SecondaryAssociationId)
        }
        set {
            objc_setAssociatedObject(self, &SecondaryAssociationId, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
