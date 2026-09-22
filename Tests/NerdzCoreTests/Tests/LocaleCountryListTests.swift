//
//  LocaleCountryListTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private enum TestData {

    static let englishIdentifier = "en_US"
    static let ukrainianIdentifier = "uk_UA"
    static let knownRegionCode = "US"
    static let unknownRegionCodes = ["ZZZ", "", "1234", "  "]

    static func createEnglishLocale() -> Locale {
        Locale(identifier: englishIdentifier)
    }

    static func createUkrainianLocale() -> Locale {
        Locale(identifier: ukrainianIdentifier)
    }
}

@Suite("Locale Country List")
struct LocaleCountryListTests {

    @Suite("Country List")
    struct CountryList {

        @Test
        func testWhenLocaleIsProvidedShouldReturnNonEmptyCountryList() {
            // Arrange
            let locale = TestData.createEnglishLocale()

            // Act
            let countries = locale.nz.countryList

            // Assert
            #expect(countries.isEmpty == false)
        }

        @Test
        func testWhenCountryListIsBuiltShouldContainKnownRegionCode() {
            // Arrange
            let locale = TestData.createEnglishLocale()
            let regionCode = TestData.knownRegionCode

            // Act
            let countries = locale.nz.countryList

            // Assert
            #expect(countries.contains { $0.code == regionCode })
        }

        @Test
        func testWhenCountryListIsBuiltShouldNotContainEmptyNames() {
            // Arrange
            let locale = TestData.createEnglishLocale()

            // Act
            let countries = locale.nz.countryList

            // Assert
            #expect(countries.allSatisfy { $0.name.nz.isWhiteSpaceOrEmpty == false })
        }

        @Test
        func testWhenCountryListIsBuiltShouldMatchLocalizedNames() throws {
            // Arrange
            let locale = TestData.createEnglishLocale()
            let regionCode = TestData.knownRegionCode

            // Act
            let countries = locale.nz.countryList

            // Assert
            let country = try #require(countries.first { $0.code == regionCode })
            #expect(country.name == locale.localizedString(forRegionCode: regionCode))
        }

        @Test
        func testWhenLocaleLanguageDiffersShouldReturnDifferentNames() throws {
            // Arrange
            let englishLocale = TestData.createEnglishLocale()
            let ukrainianLocale = TestData.createUkrainianLocale()
            let regionCode = TestData.knownRegionCode

            // Act
            let englishCountry = try #require(englishLocale.nz.country(from: regionCode))
            let ukrainianCountry = try #require(ukrainianLocale.nz.country(from: regionCode))

            // Assert
            #expect(englishCountry.name != ukrainianCountry.name)
        }
    }

    @Suite("Country From Code")
    struct CountryFromCode {

        @Test
        func testWhenRegionCodeIsValidShouldReturnCountry() throws {
            // Arrange
            let locale = TestData.createEnglishLocale()
            let regionCode = TestData.knownRegionCode

            // Act
            let country = try #require(locale.nz.country(from: regionCode))

            // Assert
            #expect(country.code == regionCode)
            #expect(country.name == locale.localizedString(forRegionCode: regionCode))
        }

        @Test(arguments: TestData.unknownRegionCodes)
        func testWhenRegionCodeIsUnknownShouldReturnNil(code: String) {
            // Arrange
            let locale = TestData.createEnglishLocale()

            // Act
            let country = locale.nz.country(from: code)

            // Assert
            #expect(country == nil)
        }
    }
}
