#if os(iOS)

import UIKit
import Testing

@testable import NerdzUIKit

private enum TestData {

    static let toggleSide: CGFloat = 30

    @MainActor
    static func textField() -> UITextField {
        UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    }

    @MainActor
    static func toggleSelector(on textField: UITextField, for button: UIButton) -> Selector? {
        button.actions(forTarget: textField, forControlEvent: .touchUpInside)?
            .map { NSSelectorFromString($0) }
            .first { textField.responds(to: $0) }
    }
}

@Suite("UITextField+PasswordVisibility")
@MainActor
struct UITextFieldPasswordVisibilityTests {

    @Suite("Toggle installation")
    @MainActor
    struct ToggleInstallation {

        @Test
        func testWhenToggleEnabledShouldInstallRightView() {
            // Arrange
            let textField = TestData.textField()

            // Act
            textField.nz_isPasswordVisiblityToggleEnabled = true

            // Assert
            #expect(textField.rightView != nil)
            #expect(textField.nz_isPasswordVisiblityToggleEnabled)
        }

        @Test
        func testWhenToggleEnabledShouldAlwaysShowRightView() {
            // Arrange
            let textField = TestData.textField()

            // Act
            textField.nz_isPasswordVisiblityToggleEnabled = true

            // Assert
            #expect(textField.rightViewMode == .always)
        }

        @Test
        func testWhenToggleEnabledShouldSizeButtonToExpectedSquare() throws {
            // Arrange
            let textField = TestData.textField()
            let side = TestData.toggleSide

            // Act
            textField.nz_isPasswordVisiblityToggleEnabled = true

            // Assert
            let button = try #require(textField.rightView)
            #expect(isClose(button.frame.size, CGSize(width: side, height: side)))
        }

        @Test
        func testWhenToggleDisabledShouldRemoveRightView() {
            // Arrange
            let textField = TestData.textField()
            textField.nz_isPasswordVisiblityToggleEnabled = true

            // Act
            textField.nz_isPasswordVisiblityToggleEnabled = false

            // Assert
            #expect(textField.rightView == nil)
            #expect(textField.nz_isPasswordVisiblityToggleEnabled == false)
        }

        @Test
        func testWhenToggleNeverEnabledShouldReportDisabled() {
            // Arrange
            let textField = TestData.textField()

            // Act
            let isEnabled = textField.nz_isPasswordVisiblityToggleEnabled

            // Assert
            #expect(isEnabled == false)
        }
    }

    @Suite("Toggle wiring")
    @MainActor
    struct ToggleWiring {

        @Test
        func testWhenToggleEnabledShouldTargetTextFieldForTouchUpInside() throws {
            // Arrange
            let textField = TestData.textField()

            // Act
            textField.nz_isPasswordVisiblityToggleEnabled = true

            // Assert
            let button = try #require(textField.rightView as? UIButton)
            #expect(button.allTargets.contains { $0.base as AnyObject === textField })
            #expect(button.allControlEvents.contains(.touchUpInside))
        }

        @Test
        func testWhenToggleEnabledShouldStartInRevealedSelection() throws {
            // Arrange
            let textField = TestData.textField()

            // Act
            textField.nz_isPasswordVisiblityToggleEnabled = true

            // Assert
            let button = try #require(textField.rightView as? UIButton)
            #expect(button.isSelected)
        }
    }

    @Suite("Toggle behaviour")
    @MainActor
    struct ToggleBehaviour {

        @Test
        func testWhenTogglePressedShouldRevealPassword() throws {
            // Arrange
            let textField = TestData.textField()
            textField.isSecureTextEntry = true
            textField.nz_isPasswordVisiblityToggleEnabled = true
            let button = try #require(textField.rightView as? UIButton)
            let selector = try #require(TestData.toggleSelector(on: textField, for: button))

            // Act
            _ = textField.perform(selector, with: button)

            // Assert
            #expect(textField.isSecureTextEntry == false)
        }

        @Test
        func testWhenTogglePressedTwiceShouldHidePasswordAgain() throws {
            // Arrange
            let textField = TestData.textField()
            textField.nz_isPasswordVisiblityToggleEnabled = true
            let button = try #require(textField.rightView as? UIButton)
            let selector = try #require(TestData.toggleSelector(on: textField, for: button))

            // Act
            _ = textField.perform(selector, with: button)
            _ = textField.perform(selector, with: button)

            // Assert
            #expect(textField.isSecureTextEntry)
        }

        @Test
        func testWhenTogglePressedShouldFlipButtonSelection() throws {
            // Arrange
            let textField = TestData.textField()
            textField.nz_isPasswordVisiblityToggleEnabled = true
            let button = try #require(textField.rightView as? UIButton)
            let selector = try #require(TestData.toggleSelector(on: textField, for: button))
            let initialSelection = button.isSelected

            // Act
            _ = textField.perform(selector, with: button)

            // Assert
            #expect(button.isSelected == !initialSelection)
        }
    }
}

#endif
