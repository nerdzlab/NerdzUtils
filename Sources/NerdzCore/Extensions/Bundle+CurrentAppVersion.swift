//
//  File.swift
//  
//
//  Created by Roman Kovalchuk on 13.07.2021.
//

import Foundation

public extension NZExtensionData where Base: Bundle {
    /// The short version string of the main bundle, for example `"2.0.0"`.
    ///
    /// The value is read from the `CFBundleShortVersionString` key of the main bundle information
    /// dictionary, so it reports the version of the running application regardless of the bundle
    /// the namespace was created from. It is `nil` when the key is missing, which happens for
    /// example in unit test bundles.
    var appVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
