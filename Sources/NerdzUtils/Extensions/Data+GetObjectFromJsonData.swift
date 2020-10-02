//
//  Data+GetObjectFromJsonData.swift
//  
//
//  Created by Roman Kovalchuk on 28.09.2020.
//

import Foundation

public extension Data {
    
    ///
    /// Return object from JSON Data
    /// - Parameter of: Target type
    ///
    @available(iOS 11.0, *)
    func object<TResult: Decodable>(of _: TResult.Type) throws -> TResult? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(TResult.self, from: self)
    }
    
    ///
    /// Return object from JSON Data
    /// - Parameter of: Target type
    ///
    @available(iOS 11.0, *)
    func object<TResult: Decodable>() throws -> TResult? {
        return try self.object(of: TResult.self)
    }
}
