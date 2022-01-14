//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation
import UIKit

public extension NZExtensionData where Base: DispatchQueue {
    
    /// Execute once per provided token
    /// - Parameters:
    ///   - token: A uniqueue associated with
    ///   - action: Execution acrtion
    class func once(per object: AnyObject, token: String, action: () -> Void) {
        let finalToken = self.token(for: object) + "." + token
        once(for: finalToken, action: action)
    }
    
    /// Execute once per provided token
    /// - Parameters:
    ///   - token: A uniqueue associated with
    ///   - action: Execution acrtion
    class func once(for token: String, action: () -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if DispatchQueue.onceTracker.contains(token) {
            return
        }
        
        DispatchQueue.onceTracker.append(token)
        action()
    }
    
    private static func token(for object: AnyObject) -> String {
        
        if let token = objc_getAssociatedObject(object, &DispatchQueue.Constants.tokenAssociationKey) as? String {
            return token
        }
        else {
            let token = UUID().uuidString
            objc_setAssociatedObject(
                object,
                &DispatchQueue.Constants.tokenAssociationKey,
                token,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            
            return token
        }
    }
}

private extension DispatchQueue {
    enum Constants {
        static var tokenAssociationKey = "tokenAssociationKey"
    }
    
    static var onceTracker = [String]()
}
