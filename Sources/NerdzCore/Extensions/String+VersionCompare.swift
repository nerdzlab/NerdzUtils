//
//  String+Compare.swift
//  ayadi
//
//  Created by Mykhailo on 02.11.2020.
//  Copyright © 2020 NerdzLab. All rights reserved.
//

import Foundation

private enum Constants {
    static let versionDelimiter = "."
    static let missingComponent = "0"
}

/// Version comparison helpers for dot separated version strings.
///
/// Both strings are split on `"."` and the components are compared one by one from left to right,
/// numerically rather than alphabetically. That makes `"1.10"` greater than `"1.9"`, which a plain
/// string comparison would get wrong. When one version has fewer components than the other the
/// missing components are treated as zero, so `"1.0"` and `"1.0.0"` are equal. A component that is
/// not a whole number, for example `"1.0-beta"`, falls back to a numeric aware string comparison of
/// that component.
public extension NZExtensionData where Base == String {
    /// Compares the receiver with another version string and reports whether they are equal.
    ///
    /// ```swift
    /// "1.0".nz.isVersion(equalTo: "1.0.0")  // true
    /// ```
    ///
    /// - Parameter targetVersion: The version to compare against.
    /// - Returns: `true` when every component of both versions is equal.
    func isVersion(equalTo targetVersion: String) -> Bool {
        compare(toVersion: targetVersion) == .orderedSame
    }

    /// Compares the receiver with another version string and reports whether it is newer.
    ///
    /// ```swift
    /// "1.10".nz.isVersion(greaterThan: "1.9")  // true
    /// ```
    ///
    /// - Parameter targetVersion: The version to compare against.
    /// - Returns: `true` when the receiver is greater than `targetVersion`.
    func isVersion(greaterThan targetVersion: String) -> Bool {
        compare(toVersion: targetVersion) == .orderedDescending
    }

    /// Compares the receiver with another version string and reports whether it is newer or equal.
    ///
    /// - Parameter targetVersion: The version to compare against.
    /// - Returns: `true` when the receiver is greater than or equal to `targetVersion`.
    func isVersion(greaterThanOrEqualTo targetVersion: String) -> Bool {
        compare(toVersion: targetVersion) != .orderedAscending
    }

    /// Compares the receiver with another version string and reports whether it is older.
    ///
    /// ```swift
    /// "1.9".nz.isVersion(lessThan: "1.10")  // true
    /// ```
    ///
    /// - Parameter targetVersion: The version to compare against.
    /// - Returns: `true` when the receiver is less than `targetVersion`.
    func isVersion(lessThan targetVersion: String) -> Bool {
        compare(toVersion: targetVersion) == .orderedAscending
    }

    /// Compares the receiver with another version string and reports whether it is older or equal.
    ///
    /// - Parameter targetVersion: The version to compare against.
    /// - Returns: `true` when the receiver is less than or equal to `targetVersion`.
    func isVersion(lessThanOrEqualTo targetVersion: String) -> Bool {
        compare(toVersion: targetVersion) != .orderedDescending
    }

    private func compare(toVersion targetVersion: String) -> ComparisonResult {
        let versionComponents = base.components(separatedBy: Constants.versionDelimiter)
        let targetComponents = targetVersion.components(separatedBy: Constants.versionDelimiter)
        let componentCount = max(versionComponents.count, targetComponents.count)

        for index in 0..<componentCount {
            let versionComponent = versionComponents[safe: index] ?? Constants.missingComponent
            let targetComponent = targetComponents[safe: index] ?? Constants.missingComponent
            let result = Self.compare(component: versionComponent, toComponent: targetComponent)

            guard result == .orderedSame else {
                return result
            }
        }

        return .orderedSame
    }

    private static func compare(component: String, toComponent targetComponent: String) -> ComparisonResult {
        guard let value = Int(component), let targetValue = Int(targetComponent) else {
            return component.compare(targetComponent, options: .numeric)
        }

        if value == targetValue {
            return .orderedSame
        }

        return value < targetValue ? .orderedAscending : .orderedDescending
    }
}
