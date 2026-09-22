//
//  File.swift
//  
//
//  Created by Roman Kovalchuk on 13.07.2021.
//

import Foundation

public extension NZExtensionData where Base: Bundle {
    /// Current application version
    var appVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
