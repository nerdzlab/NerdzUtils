//
//  BundleCurrentAppVersionTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private final class BundleAnchor: NSObject { }

private enum TestData {

    static let shortVersionKey = "CFBundleShortVersionString"

    static func createMainBundle() -> Bundle {
        .main
    }

    static func createTestBundle() -> Bundle {
        Bundle(for: BundleAnchor.self)
    }
}

@Suite("Bundle Current App Version")
struct BundleCurrentAppVersionTests {

    @Test
    func testWhenAccessedOnMainBundleShouldReturnShortVersionFromInfoDictionary() {
        // Arrange
        let bundle = TestData.createMainBundle()
        let expectedVersion = bundle.object(forInfoDictionaryKey: TestData.shortVersionKey) as? String

        // Act
        let version = bundle.nz.appVersion

        // Assert
        #expect(version == expectedVersion)
    }

    @Test
    func testWhenAccessedOnBundleShouldReadThatBundle() {
        // Arrange
        let testBundle = TestData.createTestBundle()
        let expectedVersion = testBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String

        // Act
        let version = testBundle.nz.appVersion

        // Assert
        #expect(version == expectedVersion)
    }

    @Test
    func testWhenMainBundleHasNoShortVersionShouldReturnNil() throws {
        // Arrange
        let bundle = TestData.createMainBundle()

        try #require(bundle.object(forInfoDictionaryKey: TestData.shortVersionKey) == nil)

        // Act
        let version = bundle.nz.appVersion

        // Assert
        #expect(version == nil)
    }
}
