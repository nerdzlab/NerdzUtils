//
//  Encodable+JsonData.swift
//  
//
//  Created by Roman Kovalchuk on 28.09.2020.
//

import Foundation

extension Encodable {
    
    /// The receiver encoded as UTF8 JSON data, or `nil` when encoding fails.
    ///
    /// Encoding uses a `JSONEncoder` with the `.iso8601` date encoding strategy, which matches the
    /// decoding side of ``NZExtensionData/object(of:)``.
    @available(iOS 11.0, macOS 10.12, *)
    package var nz_jsonData: Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let json = try? encoder.encode(self) else { return nil }
        return String(data: json, encoding: .utf8)?.data(using: .utf8)
    }
}
