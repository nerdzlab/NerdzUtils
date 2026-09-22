//
//  TemporaryDefaults.swift
//  NerdzCoreTests
//

import Foundation
import Testing

struct TemporaryDefaults {

    let suiteName: String
    let defaults: UserDefaults

    init() throws {
        let suiteName = "nz.core.tests.\(UUID().uuidString)"
        self.suiteName = suiteName
        self.defaults = try #require(UserDefaults(suiteName: suiteName))
    }

    func remove() {
        defaults.removePersistentDomain(forName: suiteName)
    }
}
