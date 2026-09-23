//
//  Locale+CountryList.swift
//  NerdzUtils
//
//  Created by new user on 02.10.2020.
//

import Foundation

extension Locale: NZExtensionCompatible { }

public extension NZExtensionData where Base == Locale {
    /// An ISO region code paired with the region name localized for the receiving locale.
    typealias Country = (code: String, name: String)
    
    /// Every ISO region, with names localized for the receiving locale.
    ///
    /// Regions the locale cannot produce a name for are skipped, so the result can be shorter than
    /// the full list of ISO region codes. The order follows `Locale.isoRegionCodes`.
    ///
    /// ```swift
    /// let countries = Locale(identifier: "en_US").nz.countryList
    /// ```
    var countryList: [Country] {
        Locale.isoRegionCodes.compactMap {
            guard let name = base.localizedString(forRegionCode: $0) else {
                return nil
            }
            
            return ($0, name)
        }
    }
    
    /// Returns a single country for the given region code.
    ///
    /// - Parameter code: An ISO region code such as `"UA"`.
    /// - Returns: The code paired with its name localized for the receiving locale, or `nil` when
    ///   the locale cannot produce a name for the code.
    func country(from code: String) -> Country? {
        guard let name = base.localizedString(forRegionCode: code) else {
            return nil
        }
        
        return (code, name)
    }
}
