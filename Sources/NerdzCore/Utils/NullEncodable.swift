//
//  NullEncodable.swift
//  
//
//  Created by Roman Kovalchuk on 17.06.2022.
//

import Foundation

/// A property wrapper that encodes `nil` as an explicit JSON null instead of omitting the key.
///
/// `JSONEncoder` leaves optional properties out of the payload when they are `nil`. Wrap a property
/// in this type when the receiving API distinguishes a missing key from a null value, for example
/// when null means "clear this field".
///
/// ```swift
/// struct UpdateRequest: Encodable {
///     @NullEncodable var nickname: String?
/// }
///
/// // Encodes as {"nickname":null} rather than {}
/// let request = UpdateRequest(nickname: nil)
/// ```
@available(iOS 11.0, macOS 10.12, *)
@propertyWrapper public struct NullEncodable<T>: Encodable where T: Encodable {
    
    /// The wrapped optional value.
    public var wrappedValue: T?

    /// Creates a wrapper around the given optional value.
    ///
    /// - Parameter wrappedValue: The value to encode, which may be `nil`.
    public init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
    
    /// Encodes the wrapped value, writing a null when it is `nil`.
    ///
    /// - Parameter encoder: The encoder to write to.
    /// - Throws: Any error thrown while encoding the wrapped value.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch wrappedValue {
        case .some(let value):
            try container.encode(value)
            
        case .none:
            try container.encodeNil()
        }
    }
}
