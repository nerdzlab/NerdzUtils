//
//  String+Localization.swift
//  NerdzUtils
//
//  Created by new user on 12.09.2020.
//

import Foundation

private let overridenLacaleKey = "nz.overridenLocale"

public extension NZExtensionData where Base == String {
    /// The localized string for the receiver used as a key.
    ///
    /// Lookup normally happens in the main bundle. When ``overridenLocale`` holds a non blank
    /// language code and the main bundle contains a matching `lproj` folder, the lookup happens in
    /// that folder instead, which lets an app switch language without relying on the system
    /// setting. The key itself is returned when no translation is found.
    ///
    /// ```swift
    /// let title = "welcome.title".nz.localized
    /// ```
    var localized: String {
        var bundle: Bundle = .main
        
        if let path = Bundle.main.path(forResource: String.nz.overridenLocale, ofType: "lproj"),
           !(String.nz.overridenLocale?.nz.isWhiteSpaceOrEmpty ?? true) {
            bundle = Bundle(path: path) ?? .main
        }
        
        return NSLocalizedString(base, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
    /// The language code that ``localized`` prefers over the system language.
    ///
    /// The value is persisted in `UserDefaults.standard`, so it survives app launches. Set it to a
    /// code that matches an `lproj` folder of the main bundle, for example `"uk"`, or to `nil` to
    /// fall back to the system language.
    static var overridenLocale: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: overridenLacaleKey)
        }
        
        get {
            UserDefaults.standard.string(forKey: overridenLacaleKey)
        }
    }
}
