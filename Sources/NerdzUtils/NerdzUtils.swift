//
//  NerdzUtils.swift
//  NerdzUtils
//
//  Umbrella module preserved for compatibility with NerdzUtils 1.x.
//

@_exported import NerdzCore
@_exported import NerdzDate
@_exported import NerdzKeychain

#if os(iOS)
@_exported import NerdzUIKit
#endif

/// Compatibility aliases for the namespace types as they were named before 2.0.0.
public typealias NZUtilsExtensionData = NZExtensionData
public typealias NZUtilsExtensionCompatible = NZExtensionCompatible
