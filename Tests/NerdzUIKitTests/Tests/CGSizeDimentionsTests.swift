#if os(iOS)

import CoreGraphics
import Testing
import NerdzCore

@testable import NerdzUIKit

private enum TestData {

    static let width: CGFloat = 320
    static let height: CGFloat = 180

    static let upscaleFactor: CGFloat = 2.5
    static let downscaleFactor: CGFloat = 0.25
    static let identityFactor: CGFloat = 1
    static let zeroFactor: CGFloat = 0

    static var size: CGSize {
        CGSize(width: width, height: height)
    }

    static func scaledSize(by factor: CGFloat) -> CGSize {
        CGSize(width: width * factor, height: height * factor)
    }
}

@Suite("CGSize+Dimentions")
struct CGSizeDimentionsTests {

    @Suite("Aspect ratio constants")
    struct AspectRatioConstants {

        @Test
        func testWhenLandscapeWideRatioRequestedShouldHaveExpectedDimensions() {
            // Arrange
            let expectedWidth: CGFloat = 16
            let expectedHeight: CGFloat = 9

            // Act
            let size = CGSize.nz.w16_h9

            // Assert
            #expect(isClose(size, CGSize(width: expectedWidth, height: expectedHeight)))
        }

        @Test
        func testWhenPortraitWideRatioRequestedShouldBeTransposedLandscapeRatio() {
            // Arrange
            let landscape = CGSize.nz.w16_h9

            // Act
            let portrait = CGSize.nz.w9_h16

            // Assert
            #expect(isClose(portrait, CGSize(width: landscape.height, height: landscape.width)))
        }

        @Test
        func testWhenLandscapeClassicRatioRequestedShouldHaveExpectedDimensions() {
            // Arrange
            let expectedWidth: CGFloat = 4
            let expectedHeight: CGFloat = 3

            // Act
            let size = CGSize.nz.w4_h3

            // Assert
            #expect(isClose(size, CGSize(width: expectedWidth, height: expectedHeight)))
        }

        @Test
        func testWhenPortraitClassicRatioRequestedShouldBeTransposedLandscapeRatio() {
            // Arrange
            let landscape = CGSize.nz.w4_h3

            // Act
            let portrait = CGSize.nz.w3_h4

            // Assert
            #expect(isClose(portrait, CGSize(width: landscape.height, height: landscape.width)))
        }
    }

    @Suite("Scaling")
    struct Scaling {

        @Test
        func testWhenScaledUpShouldMultiplyBothDimensions() {
            // Arrange
            let factor = TestData.upscaleFactor
            let expected = TestData.scaledSize(by: factor)

            // Act
            let scaled = TestData.size.nz.scaled(by: factor)

            // Assert
            #expect(isClose(scaled, expected))
        }

        @Test
        func testWhenScaledDownShouldMultiplyBothDimensions() {
            // Arrange
            let factor = TestData.downscaleFactor
            let expected = TestData.scaledSize(by: factor)

            // Act
            let scaled = TestData.size.nz.scaled(by: factor)

            // Assert
            #expect(isClose(scaled, expected))
        }

        @Test
        func testWhenScaledByIdentityShouldReturnSameSize() {
            // Arrange
            let original = TestData.size

            // Act
            let scaled = original.nz.scaled(by: TestData.identityFactor)

            // Assert
            #expect(isClose(scaled, original))
        }

        @Test
        func testWhenScaledByZeroShouldReturnZeroSize() {
            // Arrange
            let original = TestData.size

            // Act
            let scaled = original.nz.scaled(by: TestData.zeroFactor)

            // Assert
            #expect(isClose(scaled, .zero))
        }

        @Test
        func testWhenScaledShouldPreserveAspectRatio() {
            // Arrange
            let original = TestData.size
            let expectedRatio = original.width / original.height

            // Act
            let scaled = original.nz.scaled(by: TestData.upscaleFactor)

            // Assert
            #expect(isClose(scaled.width / scaled.height, expectedRatio))
        }
    }
}

#endif
