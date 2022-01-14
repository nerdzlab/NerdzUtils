//
//  NZUTilsExtensionData.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 13.01.2022.
//


import Foundation

public class NZUTilsExtensionData<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol NZUtilsExtensionCompatible {
    /// Extended type
    associatedtype NZExtensionBase

    /// NZ extensions.
    static var nz: NZUTilsExtensionData<NZExtensionBase>.Type { get set }

    /// NZ extensions.
    var nz: NZUTilsExtensionData<NZExtensionBase> { get set }
}

extension NZUtilsExtensionCompatible {
    
    /// NZ extensions.
    public static var nz: NZUTilsExtensionData<Self>.Type {
        get { NZUTilsExtensionData<Self>.self }
        set { }
    }

    /// Reactive extensions.
    public var nz: NZUTilsExtensionData<Self> {
        get { NZUTilsExtensionData(self) }
        set { }
    }
}
