//
//  Encodable+JsonData.swift
//  
//
//  Created by Roman Kovalchuk on 28.09.2020.
//

import Foundation

public extension Encodable {
    
    ///
    /// Return JSON data for given object
    ///
    var jsonData: Data? {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let json = try encoder.encode(self)
            return String(data: json, encoding: .utf8)?.data(using: .utf8)
        }
        catch {
            return nil
        }
    }
}
