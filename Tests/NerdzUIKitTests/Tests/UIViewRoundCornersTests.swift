#if os(iOS)

import UIKit
import Testing
import NerdzCore

@testable import NerdzUIKit

private enum TestData {

    static let radius: CGFloat = 12
    static let borderWidth: CGFloat = 3
    static let borderColor: UIColor = .magenta
    static let corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]

    static let frame = CGRect(x: 0, y: 0, width: 100, height: 100)

    @MainActor
    static func view() -> UIView {
        UIView(frame: frame)
    }
}

@Suite("UIView+RoundCorners")
@MainActor
struct UIViewRoundCornersTests {

    @Test
    func testWhenCornersRoundedShouldApplyRadiusToLayer() {
        // Arrange
        let view = TestData.view()
        let radius = TestData.radius

        // Act
        view.nz.roundCorners(TestData.corners, radius: radius)

        // Assert
        #expect(isClose(view.layer.cornerRadius, radius))
    }

    @Test
    func testWhenCornersRoundedShouldApplyMaskedCornersToLayer() {
        // Arrange
        let view = TestData.view()
        let corners = TestData.corners

        // Act
        view.nz.roundCorners(corners, radius: TestData.radius)

        // Assert
        #expect(view.layer.maskedCorners == corners)
    }

    @Test
    func testWhenBorderNotProvidedShouldLeaveBorderInvisible() throws {
        // Arrange
        let view = TestData.view()
        let expectedWidth: CGFloat = 0

        // Act
        view.nz.roundCorners(TestData.corners, radius: TestData.radius)

        // Assert
        let layerColor = UIColor(cgColor: try #require(view.layer.borderColor))
        #expect(isClose(view.layer.borderWidth, expectedWidth))
        #expect(isClose(layerColor.rgbaComponents, UIColor.clear.rgbaComponents))
    }

    @Test
    func testWhenBorderProvidedShouldApplyColorAndWidthToLayer() throws {
        // Arrange
        let view = TestData.view()
        let color = TestData.borderColor
        let width = TestData.borderWidth

        // Act
        view.nz.roundCorners(TestData.corners, radius: TestData.radius, borderColor: color, borderWidth: width)

        // Assert
        let layerColor = UIColor(cgColor: try #require(view.layer.borderColor))
        #expect(isClose(view.layer.borderWidth, width))
        #expect(isClose(layerColor.rgbaComponents, color.rgbaComponents))
    }

    @Test
    func testWhenRoundedTwiceShouldKeepOnlyLatestConfiguration() {
        // Arrange
        let view = TestData.view()
        let finalRadius = TestData.radius
        let finalCorners: CACornerMask = [.layerMaxXMinYCorner]
        view.nz.roundCorners(TestData.corners, radius: finalRadius * 2)

        // Act
        view.nz.roundCorners(finalCorners, radius: finalRadius)

        // Assert
        #expect(isClose(view.layer.cornerRadius, finalRadius))
        #expect(view.layer.maskedCorners == finalCorners)
    }
}

#endif
