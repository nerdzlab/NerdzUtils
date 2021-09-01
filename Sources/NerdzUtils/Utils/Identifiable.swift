//
//  File.swift
//  
//
//  Created by new user on 02.09.2021.
//

import Foundation

public protocol Identifiable: Equatable {
    associatedtype IdType: Equatable
    
    var id: IdType { get }
}

public protocol StringIdentifiable: Identifiable where IdType == String {
    
}

public protocol IntIdentifiable:  Identifiable where IdType == Int {
    
}

public func == <T: Identifiable>(lhs: T, rhs: T) -> Bool {
    lhs.id == rhs.id
}
