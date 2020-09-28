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
    func getObject<TResult: Decodable>(of _: TResult.Type) -> TResult? {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .customISO8601
            return try decoder.decode(TResult.self, from: self)
        }
        catch {
            return nil
        }
    }
    
    ///
    /// Return object from JSON Data
    /// - Parameter of: Target type
    ///
    func getObject<TResult: Decodable>() -> TResult? {
        return self.getObject(of: TResult.self)
    }
}
