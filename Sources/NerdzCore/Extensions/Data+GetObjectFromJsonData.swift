//
//  Data+GetObjectFromJsonData.swift
//  
//
//  Created by Roman Kovalchuk on 28.09.2020.
//

import Foundation

extension Data: NZExtensionCompatible { }

public extension NZExtensionData where Base == Data {
    /// Decodes the receiver as JSON into the requested type.
    ///
    /// Decoding uses a `JSONDecoder` with the `.iso8601` date decoding strategy, so date properties
    /// are expected to be ISO8601 strings.
    ///
    /// ```swift
    /// let user = try data.nz.object(of: User.self)
    /// ```
    ///
    /// - Parameter type: The type to decode the JSON into.
    /// - Returns: The decoded value.
    /// - Throws: A `DecodingError` when the data is not valid JSON or does not match `type`.
    @available(iOS 11.0, macOS 10.12, *)
    func object<T: Decodable>(of type: T.Type) throws -> T? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: base)
    }
    
    /// Decodes the receiver as JSON into a type inferred from the context.
    ///
    /// This is the type inferred form of ``object(of:)``.
    ///
    /// ```swift
    /// let user: User? = try data.nz.object()
    /// ```
    ///
    /// - Returns: The decoded value.
    /// - Throws: A `DecodingError` when the data is not valid JSON or does not match the inferred
    ///   type.
    @available(iOS 11.0, macOS 10.12, *)
    func object<T: Decodable>() throws -> T? {
        return try self.object(of: T.self)
    }
}
