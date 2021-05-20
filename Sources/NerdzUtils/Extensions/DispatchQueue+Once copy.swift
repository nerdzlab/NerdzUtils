//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation

public extension DispatchQueue {
    private static var _onceTracker = [String]()

    class func once(per object: AnyObject, token: String, action: () -> Void) {
        let finalToken = self.token(for: object) + "." + token
        once(for: finalToken, action: action)
    }

    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.

     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
   class func once(for token: String, action: () -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }

        if _onceTracker.contains(token) {
            return
        }

        _onceTracker.append(token)
        action()
    }

    fileprivate static func token(for object: AnyObject) -> String {
        return String(UInt(bitPattern: ObjectIdentifier(object)))
    }
}
