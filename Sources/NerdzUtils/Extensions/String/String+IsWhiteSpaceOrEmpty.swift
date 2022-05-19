//
//  String+IsWhiteSpaceOrEmpty.swift
//  NerdzUtils
//
//  Created by Roman Kovalchuk on 17.02.2022.
//

import Foundation

import Foundation

public extension NZUtilsExtensionData where Base == String {
    var isWhiteSpaceOrEmpty: Bool {
        base.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
