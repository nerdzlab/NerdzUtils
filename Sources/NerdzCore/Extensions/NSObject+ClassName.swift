//
//  File.swift
//  
//
//  Created by new user on 20.04.2020.
//

import Foundation

extension NSObject: NZExtensionCompatible { }

public extension NZExtensionData where Base: NSObject {
    /// The name of the static type the namespace was created for.
    ///
    /// The value comes from the compile time type, so it reports the class the call was written
    /// against even when the runtime value is an instance of a subclass.
    ///
    /// ```swift
    /// UIView.nz.className  // "UIView"
    /// ```
    static var className: String {
        String(describing: Base.self)
    }
    
    /// The name of the runtime type of the wrapped object.
    ///
    /// Unlike the static `className`, this reports the actual class of the instance, so a
    /// subclass instance stored in a superclass variable reports the subclass name.
    var className: String {
        String(describing: type(of: base))
    }
}
