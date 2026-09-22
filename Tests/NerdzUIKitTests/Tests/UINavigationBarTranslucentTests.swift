#if os(iOS)

import UIKit
import Testing
import NerdzCore

@testable import NerdzUIKit

private enum TestData {

    @MainActor
    static func navigationBar() -> UINavigationBar {
        UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
    }
}

@Suite("UINavigationBar+Translucent")
@MainActor
struct UINavigationBarTranslucentTests {

    @Test(arguments: [true, false])
    func testWhenTranslucencyRequestedShouldApplyRequestedState(isTranslucent: Bool) {
        // Arrange
        let navigationBar = TestData.navigationBar()

        // Act
        navigationBar.nz.makeTranslucent(isTranslucent)

        // Assert
        #expect(navigationBar.isTranslucent == isTranslucent)
    }

    @Test
    func testWhenTranslucencyAppliedShouldClearDefaultBackgroundImage() {
        // Arrange
        let navigationBar = TestData.navigationBar()

        // Act
        navigationBar.nz.makeTranslucent(true)

        // Assert
        #expect(navigationBar.backgroundImage(for: .default) != nil)
        #expect(isClose(navigationBar.backgroundImage(for: .default)?.size ?? .zero, .zero))
    }

    @Test
    func testWhenTranslucencyAppliedShouldClearShadowImage() {
        // Arrange
        let navigationBar = TestData.navigationBar()

        // Act
        navigationBar.nz.makeTranslucent(true)

        // Assert
        #expect(navigationBar.shadowImage != nil)
        #expect(isClose(navigationBar.shadowImage?.size ?? .zero, .zero))
    }
}

#endif
