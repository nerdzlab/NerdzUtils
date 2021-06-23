//
//  Locale+CountryList.swift
//  NerdzUtils
//
//  Created by new user on 02.10.2020.
//

import Foundation

public extension Locale {
    typealias Country = (code: String, name: String)
    
    /// Returns countries list base on current device locale
    var countryList: [Country] {
        Locale.isoRegionCodes.compactMap {
            guard let name = self.localizedString(forRegionCode: $0) else {
                return nil
            }
            
            return ($0, name)
        }
    }
    
    /// Provide contry based on region code
    /// - Parameter code: Country region code
    /// - Returns: Country if such country exist
    func country(from code: String) -> Country? {
        guard let name = localizedString(forRegionCode: code) else {
            return nil
        }
        
        return (code, name)
    }
}
