//
//  String+Compare.swift
//  ayadi
//
//  Created by Mykhailo on 02.11.2020.
//  Copyright © 2020 NerdzLab. All rights reserved.
//

import Foundation

public extension String {
    private func compare(toVersion targetVersion: String) -> ComparisonResult {
        
        let versionDelimiter = "."
        var result: ComparisonResult = .orderedSame
        var versionComponents = components(separatedBy: versionDelimiter)
        var targetComponents = targetVersion.components(separatedBy: versionDelimiter)
        let spareCount = versionComponents.count - targetComponents.count
        
        if spareCount == 0 {
            result = compare(targetVersion, options: .numeric)
        }
        else {
            let spareZeros = repeatElement("0", count: abs(spareCount))
            if spareCount > 0 {
                targetComponents.append(contentsOf: spareZeros)
            }
            else {
                versionComponents.append(contentsOf: spareZeros)
            }
            result = targetComponents.joined(separator: versionDelimiter)
                .compare(versionComponents.joined(separator: versionDelimiter), options: .numeric)
        }
        return result
    }
    
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
}
