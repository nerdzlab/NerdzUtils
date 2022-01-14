//
//  NZUtilsExtensionData.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 13.01.2022.
//


import Foundation

public class NZUtilsExtensionData<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol NZUtilsExtensionCompatible {
    /// Extended type
    associatedtype NZExtensionBase

    /// NZ extensions.
    static var nz: NZUtilsExtensionData<NZExtensionBase>.Type { get set }

    /// NZ extensions.
    var nz: NZUtilsExtensionData<NZExtensionBase> { get set }
}

extension NZUtilsExtensionCompatible {
    
    /// NZ extensions.
    public static var nz: NZUtilsExtensionData<Self>.Type {
        get { NZUtilsExtensionData<Self>.self }
        set { }
    }

    /// Reactive extensions.
    public var nz: NZUtilsExtensionData<Self> {
        get { NZUtilsExtensionData(self) }
        set { }
    }
}
