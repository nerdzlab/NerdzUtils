//
//  File.swift
//  
//
//  Created by new user on 02.09.2021.
//

import Foundation

public protocol IdType: Hashable {
    associatedtype ID: Hashable
    
    var id: ID { get }
}

public protocol StringIdType: IdType where ID == String {
    
}

public protocol IntIdType:  IdType where ID == Int {
    
}

public extension IdType {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public func == <T: IdType>(lhs: T, rhs: T) -> Bool {
    lhs.id == rhs.id
}


