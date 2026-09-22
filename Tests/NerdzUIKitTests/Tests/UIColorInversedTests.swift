#if os(iOS)

import UIKit
import Testing
import NerdzCore

@testable import NerdzUIKit

private enum TestData {

    static let red: CGFloat = 0.2
    static let green: CGFloat = 0.5
    static let blue: CGFloat = 0.9
    static let alpha: CGFloat = 0.75

    static let whiteValue: CGFloat = 0.25

    static var components: RGBAComponents {
        RGBAComponents(red: red, green: green, blue: blue, alpha: alpha)
    }

    static func color() -> UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    static func grayscaleColor() -> UIColor {
        UIColor(white: whiteValue, alpha: alpha)
    }
}

@Suite("UIColor+Inversed")
struct UIColorInversedTests {

    @Suite("RGB colors")
    struct RGBColors {

        @Test
        func testWhenColorInversedShouldReturnComplementaryChannels() {
            // Arrange
            let color = TestData.color()
            let expected = TestData.components.inversed

            // Act
            let inversed = color.nz.inversed

            // Assert
            #expect(isClose(inversed.rgbaComponents, expected))
        }

        @Test
        func testWhenColorInversedShouldPreserveAlpha() {
            // Arrange
            let color = TestData.color()
            let expectedAlpha = TestData.alpha

            // Act
            let inversed = color.nz.inversed

            // Assert
            #expect(isClose(inversed.rgbaComponents.alpha, expectedAlpha))
        }

        @Test
        func testWhenColorInversedTwiceShouldReturnOriginalComponents() {
            // Arrange
            let color = TestData.color()
            let expected = color.rgbaComponents

            // Act
            let roundTripped = color.nz.inversed.nz.inversed

            // Assert
            #expect(isClose(roundTripped.rgbaComponents, expected))
        }
    }

    @Suite("Extreme colors")
    struct ExtremeColors {

        @Test
        func testWhenWhiteInversedShouldProduceBlack() {
            // Arrange
            let color = UIColor.white
            let expected = UIColor.black.rgbaComponents

            // Act
            let inversed = color.nz.inversed

            // Assert
            #expect(isClose(inversed.rgbaComponents, expected))
        }

        @Test
        func testWhenBlackInversedShouldProduceWhite() {
            // Arrange
            let color = UIColor.black
            let expected = UIColor.white.rgbaComponents

            // Act
            let inversed = color.nz.inversed

            // Assert
            #expect(isClose(inversed.rgbaComponents, expected))
        }

        @Test
        func testWhenGrayscaleColorInversedShouldReturnComplementaryWhiteValue() {
            // Arrange
            let color = TestData.grayscaleColor()
            let expectedWhite = 1 - TestData.whiteValue

            // Act
            let inversed = color.nz.inversed

            // Assert
            var white: CGFloat = 0
            var alpha: CGFloat = 0
            #expect(inversed.getWhite(&white, alpha: &alpha))
            #expect(isClose(white, expectedWhite))
            #expect(isClose(alpha, TestData.alpha))
        }
    }
}

#endif
