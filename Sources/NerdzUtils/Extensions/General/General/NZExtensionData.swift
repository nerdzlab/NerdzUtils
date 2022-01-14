//
//  NZExtensionData.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 13.01.2022.
//


import Foundation

public class NZExtensionData<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol NZExtensionCompatible {
    /// Extended type
    associatedtype NZExtensionBase

    /// NZ extensions.
    static var nz: NZExtensionData<NZExtensionBase>.Type { get set }

    /// NZ extensions.
    var nz: NZExtensionData<NZExtensionBase> { get set }
}

extension NZExtensionCompatible {
    
    /// NZ extensions.
    public static var nz: NZExtensionData<Self>.Type {
        get { NZExtensionData<Self>.self }
        set { }
    }

    /// Reactive extensions.
    public var nz: NZExtensionData<Self> {
        get { NZExtensionData(self) }
        set { }
    }
}
