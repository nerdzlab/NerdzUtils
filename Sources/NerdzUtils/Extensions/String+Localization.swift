//
//  String+Localization.swift
//  NerdzUtils
//
//  Created by new user on 12.09.2020.
//

import Foundation

private let overridenLacaleKey = "nz.overridenLocale"

public extension String {
    /// Return localized representation of current string
    var localized: String {
        var bundle: Bundle = .main
        
        if let path = Bundle.main.path(forResource: String.overridenLocale, ofType: "lproj") {
            bundle = Bundle(path: path) ?? .main
        }
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
    static var overridenLocale: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: overridenLacaleKey)
        }
        
        get {
            UserDefaults.standard.string(forKey: overridenLacaleKey)
        }
    }
}
