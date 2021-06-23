//
//  Data+GetObjectFromJsonData.swift
//  
//
//  Created by Roman Kovalchuk on 28.09.2020.
//

import Foundation

public extension Data {
    
    /// Return object from JSON Data
    /// - Parameter of: Target type
    @available(iOS 11.0, *)
    func object<T: Decodable>(of _: T.Type) throws -> T? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: self)
    }
    
    /// Return object from JSON Data
    /// - Parameter of: Target type
    @available(iOS 11.0, *)
    func object<T: Decodable>() throws -> T? {
        return try self.object(of: T.self)
    }
}
