//
//  NZExtensionData.swift
//  NerdzCore
//
//  Created by Roman Kovalchuk on 13.01.2022.
//

import Foundation

/// A lightweight box that carries a value into the `.nz` namespace.
///
/// Every helper that NerdzCore adds to a Foundation type lives in an extension of this type,
/// constrained to the type being extended. That keeps the global namespace of types such as
/// `String`, `Data` or `Locale` free of library specific members, because the helpers are only
/// reachable through `.nz`.
///
/// ```swift
/// let version = "1.10".nz.isVersion(greaterThan: "1.9")
/// ```
///
/// Types opt into the namespace by conforming to ``NZExtensionCompatible``.
public struct NZExtensionData<Base> {

    /// The value the namespace was created from.
    public let base: Base

    /// Creates a namespace box around the given value.
    ///
    /// Call sites normally use the `.nz` property of ``NZExtensionCompatible`` instead of this
    /// initializer.
    ///
    /// - Parameter base: The value the namespace helpers operate on.
    public init(_ base: Base) {
        self.base = base
    }
}

extension NZExtensionData: Sendable where Base: Sendable { }

/// A type that exposes NerdzCore helpers through a `.nz` namespace.
///
/// Conforming to this protocol requires no implementation, because the default implementation
/// supplies both the instance and the static `nz` property.
///
/// ```swift
/// extension MyType: NZExtensionCompatible { }
///
/// extension NZExtensionData where Base == MyType {
///     var description: String { "\(base)" }
/// }
/// ```
public protocol NZExtensionCompatible {
    /// The type the namespace helpers are attached to.
    associatedtype NZExtensionBase

    /// The type level entry point of the `.nz` namespace.
    static var nz: NZExtensionData<NZExtensionBase>.Type { get }

    /// The instance level entry point of the `.nz` namespace.
    var nz: NZExtensionData<NZExtensionBase> { get }
}

extension NZExtensionCompatible {

    /// The type level entry point of the `.nz` namespace.
    ///
    /// Use it to reach the static helpers, for example `String.nz.overridenLocale`.
    public static var nz: NZExtensionData<Self>.Type {
        get { NZExtensionData<Self>.self }
    }

    /// The instance level entry point of the `.nz` namespace.
    ///
    /// Use it to reach the instance helpers, for example `"text".nz.isWhiteSpaceOrEmpty`.
    public var nz: NZExtensionData<Self> {
        get { NZExtensionData(self) }
    }
}
