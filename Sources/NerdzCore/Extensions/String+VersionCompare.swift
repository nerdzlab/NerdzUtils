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

public extension NZExtensionData where Base == String {
    func isVersion(equalTo targetVersion: String) -> Bool {
        compare(toVersion: targetVersion) == .orderedSame
    }

    func isVersion(greaterThan targetVersion: String) -> Bool {
        compare(toVersion: targetVersion) == .orderedDescending
    }

    func isVersion(greaterThanOrEqualTo targetVersion: String) -> Bool {
        compare(toVersion: targetVersion) != .orderedAscending
    }

    func isVersion(lessThan targetVersion: String) -> Bool {
        compare(toVersion: targetVersion) == .orderedAscending
    }

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
