//
//  Locale+CountryList.swift
//  NerdzUtils
//
//  Created by new user on 02.10.2020.
//

import Foundation

extension Locale: NZUtilsExtensionCompatible { }

public extension NZUtilsExtensionData where Base == Locale {
    typealias Country = (code: String, name: String)
    
    /// Returns countries list base on current device locale
    var countryList: [Country] {
        Locale.isoRegionCodes.compactMap {
            guard let name = base.localizedString(forRegionCode: $0) else {
                return nil
            }
            
            return ($0, name)
        }
    }
    
    /// Provide contry based on region code
    /// - Parameter code: Country region code
    /// - Returns: Country if such country exist
    func country(from code: String) -> Country? {
        guard let name = base.localizedString(forRegionCode: code) else {
            return nil
        }
        
        return (code, name)
    }
}
