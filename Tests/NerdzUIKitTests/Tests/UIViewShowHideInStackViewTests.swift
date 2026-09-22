#if os(iOS)

import UIKit
import Testing
import NerdzCore

@testable import NerdzUIKit

private enum TestData {

    static let untouchedAlpha: CGFloat = 0.42
    static let animationDuration: CGFloat = 0.01

    @MainActor
    static func stackView(with arrangedView: UIView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [arrangedView])
        stackView.axis = .vertical
        stackView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return stackView
    }

    @MainActor
    static func arrangedView() -> UIView {
        UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    }
}

@Suite("UIView+ShowHideInStackView")
@MainActor
struct UIViewShowHideInStackViewTests {

    @Suite("Hiding")
    @MainActor
    struct Hiding {

        @Test
        func testWhenVisibleViewHiddenShouldMarkItHidden() {
            // Arrange
            let view = TestData.arrangedView()
            let stackView = TestData.stackView(with: view)

            // Act
            view.nz.hideAnimated(in: stackView, duration: TestData.animationDuration)

            // Assert
            #expect(view.isHidden)
        }

        @Test
        func testWhenVisibleViewHiddenShouldMakeItTransparent() {
            // Arrange
            let view = TestData.arrangedView()
            let stackView = TestData.stackView(with: view)
            let expectedAlpha: CGFloat = 0

            // Act
            view.nz.hideAnimated(in: stackView, duration: TestData.animationDuration)

            // Assert
            #expect(isClose(view.alpha, expectedAlpha))
        }

        @Test
        func testWhenAlreadyHiddenViewHiddenShouldLeaveAlphaUntouched() {
            // Arrange
            let view = TestData.arrangedView()
            let stackView = TestData.stackView(with: view)
            let alpha = TestData.untouchedAlpha
            view.isHidden = true
            view.alpha = alpha

            // Act
            view.nz.hideAnimated(in: stackView, duration: TestData.animationDuration)

            // Assert
            #expect(isClose(view.alpha, alpha))
        }
    }

    @Suite("Showing")
    @MainActor
    struct Showing {

        @Test
        func testWhenHiddenViewShownShouldMarkItVisible() {
            // Arrange
            let view = TestData.arrangedView()
            let stackView = TestData.stackView(with: view)
            view.isHidden = true

            // Act
            view.nz.showAnimated(in: stackView, duration: TestData.animationDuration)

            // Assert
            #expect(view.isHidden == false)
        }

        @Test
        func testWhenHiddenViewShownShouldMakeItOpaque() {
            // Arrange
            let view = TestData.arrangedView()
            let stackView = TestData.stackView(with: view)
            let expectedAlpha: CGFloat = 1
            view.isHidden = true
            view.alpha = 0

            // Act
            view.nz.showAnimated(in: stackView, duration: TestData.animationDuration)

            // Assert
            #expect(isClose(view.alpha, expectedAlpha))
        }

        @Test
        func testWhenAlreadyVisibleViewShownShouldLeaveAlphaUntouched() {
            // Arrange
            let view = TestData.arrangedView()
            let stackView = TestData.stackView(with: view)
            let alpha = TestData.untouchedAlpha
            view.alpha = alpha

            // Act
            view.nz.showAnimated(in: stackView, duration: TestData.animationDuration)

            // Assert
            #expect(isClose(view.alpha, alpha))
        }
    }

    @Suite("Round trip")
    @MainActor
    struct RoundTrip {

        @Test
        func testWhenViewHiddenAndShownShouldReturnToInitialState() {
            // Arrange
            let view = TestData.arrangedView()
            let stackView = TestData.stackView(with: view)
            let initialIsHidden = view.isHidden
            let initialAlpha = view.alpha

            // Act
            view.nz.hideAnimated(in: stackView, duration: TestData.animationDuration)
            view.nz.showAnimated(in: stackView, duration: TestData.animationDuration)

            // Assert
            #expect(view.isHidden == initialIsHidden)
            #expect(isClose(view.alpha, initialAlpha))
        }
    }
}

#endif
