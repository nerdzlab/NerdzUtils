//
//  File.swift
//  
//
//  Created by Roman Kovalchuk on 13.07.2021.
//

import Foundation

public extension NZExtensionData where Base: Bundle {
    /// The short version string of the bundle, for example `"2.0.0"`.
    ///
    /// The value is read from the `CFBundleShortVersionString` key of the information dictionary
    /// of the bundle the namespace was created from, so `Bundle.main.nz.appVersion` reports the
    /// application version while a framework bundle reports its own. It is `nil` when the key is
    /// missing, which happens for example in unit test bundles.
    var appVersion: String? {
        base.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
