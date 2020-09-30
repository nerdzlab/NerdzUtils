//
//  Encodable+JsonData.swift
//  
//
//  Created by Roman Kovalchuk on 28.09.2020.
//

import Foundation

extension Encodable {
    
    ///
    /// Return JSON data for given object
    ///
    @available(iOS 11.0, *)
    var jsonData: Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let json = try? encoder.encode(self) else { return nil }
        return String(data: json, encoding: .utf8)?.data(using: .utf8)
    }
}
