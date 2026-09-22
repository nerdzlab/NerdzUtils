//
//  NullEncodable.swift
//  
//
//  Created by Roman Kovalchuk on 17.06.2022.
//

import Foundation

@available(iOS 11.0, macOS 10.12, *)
@propertyWrapper public struct NullEncodable<T>: Encodable where T: Encodable {
    
    public var wrappedValue: T?

    public init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
    
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
