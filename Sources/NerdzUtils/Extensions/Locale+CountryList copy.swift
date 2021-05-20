//
//  Locale+CountryList.swift
//  NerdzUtils
//
//  Created by new user on 02.10.2020.
//

import Foundation

public extension Locale {
    typealias Country = (code: String, name: String)

    var countryList: [Country] {
        Locale.isoRegionCodes.compactMap {
            guard let name = self.localizedString(forRegionCode: $0) else {
                return nil
            }
            
            return ($0, name)
        }
    }
    
    func country(from code: String) -> Country? {
        guard let name = localizedString(forRegionCode: code) else {
            return nil
        }
        
        return (code, name)
    }
}
