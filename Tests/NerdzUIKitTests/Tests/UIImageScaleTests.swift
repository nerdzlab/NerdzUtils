#if os(iOS)

import UIKit
import Testing
import NerdzCore

@testable import NerdzUIKit

private enum TestData {

    static let landscapeWidth: CGFloat = 200
    static let landscapeHeight: CGFloat = 100

    static let targetWidth: CGFloat = 50
    static let targetHeight: CGFloat = 25
    static let scaleFactor: CGFloat = 0.5

    @MainActor
    static func landscapeImage() -> UIImage {
        TestImageFactory.image(of: landscapeSize)
    }

    @MainActor
    static func portraitImage() -> UIImage {
        TestImageFactory.image(of: portraitSize)
    }

    static var landscapeSize: CGSize {
        CGSize(width: landscapeWidth, height: landscapeHeight)
    }

    static var portraitSize: CGSize {
        CGSize(width: landscapeHeight, height: landscapeWidth)
    }

    static var aspectRatio: CGFloat {
        landscapeWidth / landscapeHeight
    }
}

@Suite("UIImage+Scale")
@MainActor
struct UIImageScaleTests {

    @Suite("Single dimension scaling")
    @MainActor
    struct SingleDimensionScaling {

        @Test
        func testWhenScaledToWidthShouldMatchRequestedWidth() {
            // Arrange
            let image = TestData.landscapeImage()
            let width = TestData.targetWidth

            // Act
            let scaled = image.nz.scaled(toWidth: width)

            // Assert
            #expect(isClose(scaled.size.width, width, tolerance: Tolerance.dimension))
        }

        @Test
        func testWhenScaledToWidthShouldPreserveAspectRatio() {
            // Arrange
            let image = TestData.landscapeImage()
            let expectedRatio = TestData.aspectRatio

            // Act
            let scaled = image.nz.scaled(toWidth: TestData.targetWidth)

            // Assert
            #expect(isClose(scaled.size.width / scaled.size.height, expectedRatio, tolerance: Tolerance.dimension))
        }

        @Test
        func testWhenScaledToHeightShouldMatchRequestedHeight() {
            // Arrange
            let image = TestData.landscapeImage()
            let height = TestData.targetHeight

            // Act
            let scaled = image.nz.scaled(toHeight: height)

            // Assert
            #expect(isClose(scaled.size.height, height, tolerance: Tolerance.dimension))
        }
    }

    @Suite("Bigger and smaller side scaling")
    @MainActor
    struct BiggerAndSmallerSideScaling {

        @Test
        func testWhenLandscapeScaledToBiggerShouldApplyValueToWidth() {
            // Arrange
            let image = TestData.landscapeImage()
            let value = TestData.targetWidth

            // Act
            let scaled = image.nz.scaled(toBigger: value)

            // Assert
            #expect(isClose(scaled.size.width, value, tolerance: Tolerance.dimension))
        }

        @Test
        func testWhenPortraitScaledToBiggerShouldApplyValueToHeight() {
            // Arrange
            let image = TestData.portraitImage()
            let value = TestData.targetWidth

            // Act
            let scaled = image.nz.scaled(toBigger: value)

            // Assert
            #expect(isClose(scaled.size.height, value, tolerance: Tolerance.dimension))
        }

        @Test
        func testWhenLandscapeScaledToSmallerShouldApplyValueToHeight() {
            // Arrange
            let image = TestData.landscapeImage()
            let value = TestData.targetHeight

            // Act
            let scaled = image.nz.scaled(toSmaller: value)

            // Assert
            #expect(isClose(scaled.size.height, value, tolerance: Tolerance.dimension))
        }

        @Test
        func testWhenPortraitScaledToSmallerShouldApplyValueToWidth() {
            // Arrange
            let image = TestData.portraitImage()
            let value = TestData.targetHeight

            // Act
            let scaled = image.nz.scaled(toSmaller: value)

            // Assert
            #expect(isClose(scaled.size.width, value, tolerance: Tolerance.dimension))
        }
    }

    @Suite("Fit and factor scaling")
    @MainActor
    struct FitAndFactorScaling {

        @Test
        func testWhenScaledToFitShouldNotExceedTargetSize() {
            // Arrange
            let image = TestData.landscapeImage()
            let target = CGSize(width: TestData.targetWidth, height: TestData.targetWidth)

            // Act
            let scaled = image.nz.scaled(toFit: target)

            // Assert
            #expect(scaled.size.width <= target.width + Tolerance.dimension)
            #expect(scaled.size.height <= target.height + Tolerance.dimension)
        }

        @Test
        func testWhenScaledToFitSquareShouldUseLimitingDimension() {
            // Arrange
            let image = TestData.landscapeImage()
            let side = TestData.targetWidth
            let expected = CGSize(width: side, height: side / TestData.aspectRatio)

            // Act
            let scaled = image.nz.scaled(toFit: CGSize(width: side, height: side))

            // Assert
            #expect(isClose(scaled.size, expected, tolerance: Tolerance.dimension))
        }

        @Test
        func testWhenScaledByFactorShouldMultiplyOriginalSize() {
            // Arrange
            let image = TestData.landscapeImage()
            let factor = TestData.scaleFactor
            let expected = TestData.landscapeSize.nz.scaled(by: factor)

            // Act
            let scaled = image.nz.scaled(by: factor)

            // Assert
            #expect(isClose(scaled.size, expected, tolerance: Tolerance.dimension))
        }

        @Test
        func testWhenScaledByIdentityFactorShouldKeepOriginalSize() {
            // Arrange
            let image = TestData.landscapeImage()
            let expected = image.size

            // Act
            let scaled = image.nz.scaled(by: 1)

            // Assert
            #expect(isClose(scaled.size, expected, tolerance: Tolerance.dimension))
        }
    }
}

#endif
