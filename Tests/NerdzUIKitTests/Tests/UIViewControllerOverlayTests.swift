#if os(iOS)

import UIKit
import Testing
import NerdzCore

@testable import NerdzUIKit

private enum TestData {

    @MainActor
    static func controllerWithoutWindow() -> UIViewController {
        UIViewController()
    }

    @MainActor
    static func window() -> UIWindow {
        UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    }
}

@Suite("UIViewController+Overlay")
@MainActor
struct UIViewControllerOverlayTests {

    @Suite("Dismiss validation")
    @MainActor
    struct DismissValidation {

        @Test
        func testWhenControllerHasNoWindowShouldThrowNoWindowError() {
            // Arrange
            let controller = TestData.controllerWithoutWindow()
            var didThrowNoWindow = false

            // Act
            do {
                try controller.nz.dismissOverlay()
            }
            catch OverlayPresentationError.noWindow {
                didThrowNoWindow = true
            }
            catch {
                didThrowNoWindow = false
            }

            // Assert
            #expect(didThrowNoWindow)
        }
    }

    @Suite("Error descriptions")
    @MainActor
    struct ErrorDescriptions {

        @Test
        func testWhenErrorsInspectedShouldCarryDistinctDescriptions() {
            // Arrange
            let noWindow = OverlayPresentationError.noWindow
            let notOverlay = OverlayPresentationError.notOverlay

            // Act
            let descriptions = [noWindow.localizedDescription, notOverlay.localizedDescription]

            // Assert
            #expect(Set(descriptions).count == descriptions.count)
            #expect(descriptions.allSatisfy { $0.isEmpty == false })
        }
    }

    @Suite("Default window configuration")
    @MainActor
    struct DefaultWindowConfiguration {

        @Test
        func testWhenDefaultConfigurationAppliedShouldRaiseWindowToAlertLevel() {
            // Arrange
            let window = TestData.window()

            // Act
            UIViewController.nz.defaultWindowConfiguration(window)

            // Assert
            #expect(window.windowLevel == .alert)
        }

        @Test
        func testWhenDefaultConfigurationAppliedShouldMakeBackgroundTransparent() throws {
            // Arrange
            let window = TestData.window()

            // Act
            UIViewController.nz.defaultWindowConfiguration(window)

            // Assert
            let background = try #require(window.backgroundColor)
            #expect(isClose(background.rgbaComponents, UIColor.clear.rgbaComponents))
        }
    }
}

#endif
