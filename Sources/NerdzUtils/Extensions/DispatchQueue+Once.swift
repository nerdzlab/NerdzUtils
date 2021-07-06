//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation

public extension DispatchQueue {
    private enum Constants {
        static var tokenAssociationKey = "tokenAssociationKey"
    }
    
    private static var _onceTracker = [String]()

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

        if _onceTracker.contains(token) {
            return
        }

        _onceTracker.append(token)
        action()
    }

    fileprivate static func token(for object: AnyObject) -> String {
        
        if let token = objc_getAssociatedObject(object, &Constants.tokenAssociationKey) as? String {
            return token
        }
        else {
            let token = UUID().uuidString
            objc_setAssociatedObject(object, &Constants.tokenAssociationKey, token, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return token
        }
    }
}
