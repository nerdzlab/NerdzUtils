//
//  Data+GetObjectFromJsonData.swift
//  
//
//  Created by Roman Kovalchuk on 28.09.2020.
//

import Foundation

extension Data: NZExtensionCompatible { }

public extension NZExtensionData where Base == Data {
    /// Return object from JSON Data
    /// - Parameter type: Target type
    @available(iOS 11.0, macOS 10.12, *)
    func object<T: Decodable>(of type: T.Type) throws -> T? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: base)
    }
    
    /// Return object from JSON Data
    @available(iOS 11.0, macOS 10.12, *)
    func object<T: Decodable>() throws -> T? {
        return try self.object(of: T.self)
    }
}
