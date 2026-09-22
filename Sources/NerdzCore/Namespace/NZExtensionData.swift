//
//  NZExtensionData.swift
//  NerdzCore
//
//  Created by Roman Kovalchuk on 13.01.2022.
//

import Foundation

public struct NZExtensionData<Base> {

    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }
}

extension NZExtensionData: Sendable where Base: Sendable { }

public protocol NZExtensionCompatible {
    /// Extended type
    associatedtype NZExtensionBase

    /// NZ extensions.
    static var nz: NZExtensionData<NZExtensionBase>.Type { get }

    /// NZ extensions.
    var nz: NZExtensionData<NZExtensionBase> { get }
}

extension NZExtensionCompatible {

    /// NZ extensions.
    public static var nz: NZExtensionData<Self>.Type {
        get { NZExtensionData<Self>.self }
    }

    /// NZ extensions.
    public var nz: NZExtensionData<Self> {
        get { NZExtensionData(self) }
    }
}
