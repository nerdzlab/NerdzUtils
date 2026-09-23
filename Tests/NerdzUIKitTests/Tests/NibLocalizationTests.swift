#if os(iOS)

import UIKit
import Testing
import NerdzCore

@testable import NerdzUIKit

private enum TestData {

    static let missingKey = "nz.tests.missing.localization.key"
    static let anotherMissingKey = "nz.tests.another.missing.localization.key"
    static let presetText = "Preset text"
}

@Suite("Nib localization helpers")
@MainActor
struct NibLocalizationTests {

    @Suite("UILabel")
    @MainActor
    struct Label {

        @Test
        func testWhenLocalizationKeyAssignedShouldSetResolvedTextOnLabel() {
            // Arrange
            let label = UILabel()
            let key = TestData.missingKey

            // Act
            label.nz.textLocalization = key

            // Assert
            #expect(label.text == key.nz.localized)
        }

        @Test
        func testWhenInspectableLocalizationKeyAssignedShouldSetResolvedTextOnLabel() {
            // Arrange
            let label = UILabel()
            let key = TestData.missingKey

            // Act
            label.nz_textLocalization = key

            // Assert
            #expect(label.text == key.nz.localized)
        }

        @Test
        func testWhenLocalizationKeyIsNilShouldLeaveExistingTextUntouched() {
            // Arrange
            let label = UILabel()
            let text = TestData.presetText
            label.text = text

            // Act
            label.nz.textLocalization = nil

            // Assert
            #expect(label.text == text)
        }

        @Test
        func testWhenLocalizationKeyReadBackShouldReturnNil() {
            // Arrange
            let label = UILabel()
            label.nz.textLocalization = TestData.missingKey

            // Act
            let readBack = label.nz.textLocalization

            // Assert
            #expect(readBack == nil)
        }
    }

    @Suite("UIButton")
    @MainActor
    struct Button {

        @Test
        func testWhenLocalizationKeyAssignedShouldSetResolvedNormalTitle() {
            // Arrange
            let button = UIButton(type: .system)
            let key = TestData.missingKey

            // Act
            button.nz.textLocalization = key

            // Assert
            #expect(button.title(for: .normal) == key.nz.localized)
        }

        @Test
        func testWhenInspectableLocalizationKeyAssignedShouldSetResolvedNormalTitle() {
            // Arrange
            let button = UIButton(type: .system)
            let key = TestData.missingKey

            // Act
            button.nz_textLocalization = key

            // Assert
            #expect(button.title(for: .normal) == key.nz.localized)
        }

        @Test
        func testWhenLocalizationKeyIsNilShouldLeaveExistingTitleUntouched() {
            // Arrange
            let button = UIButton(type: .system)
            let text = TestData.presetText
            button.setTitle(text, for: .normal)

            // Act
            button.nz.textLocalization = nil

            // Assert
            #expect(button.title(for: .normal) == text)
        }
    }

    @Suite("UITextField")
    @MainActor
    struct TextField {

        @Test
        func testWhenLocalizationKeyAssignedShouldSetResolvedText() {
            // Arrange
            let textField = UITextField()
            let key = TestData.missingKey

            // Act
            textField.nz.textLocalization = key

            // Assert
            #expect(textField.text == key.nz.localized)
        }

        @Test
        func testWhenPlaceholderLocalizationKeyAssignedShouldSetResolvedPlaceholder() {
            // Arrange
            let textField = UITextField()
            let key = TestData.anotherMissingKey

            // Act
            textField.nz.placeholderLocalization = key

            // Assert
            #expect(textField.placeholder == key.nz.localized)
        }

        @Test
        func testWhenBothLocalizationKeysAssignedShouldSetThemIndependently() {
            // Arrange
            let textField = UITextField()
            let textKey = TestData.missingKey
            let placeholderKey = TestData.anotherMissingKey

            // Act
            textField.nz_textLocalization = textKey
            textField.nz_placeholderLocalization = placeholderKey

            // Assert
            #expect(textField.text == textKey.nz.localized)
            #expect(textField.placeholder == placeholderKey.nz.localized)
        }
    }

    @Suite("Missing key fallback")
    @MainActor
    struct MissingKeyFallback {

        @Test
        func testWhenKeyIsNotInBundleShouldFallBackToKeyItself() {
            // Arrange
            let key = TestData.missingKey

            // Act
            let localized = key.nz.localized

            // Assert
            #expect(localized == key)
        }
    }
}

#endif
