#if os(iOS)

import UIKit
import Testing
import NerdzCore

@testable import NerdzUIKit

private enum TestData {

    static let cornerRadius: CGFloat = 14
    static let borderWidth: CGFloat = 2.5
    static let borderColor: UIColor = .systemBlue
    static let shadowColor: UIColor = .systemPink
    static let shadowAlpha: Float = 0.66
    static let shadowOffset = CGSize(width: -3, height: 7)
    static let shadowBlur: CGFloat = 9
    static let maskedCorners: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

    @MainActor
    static func view() -> UIView {
        UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    }
}

@Suite("UIView+InspectableLayer")
@MainActor
struct UIViewInspectableLayerTests {

    @Suite("Namespaced accessors")
    @MainActor
    struct NamespacedAccessors {

        @Test
        func testWhenCornerRadiusSetShouldWriteAndReadBackSameValue() {
            // Arrange
            let view = TestData.view()
            let radius = TestData.cornerRadius

            // Act
            view.nz.cornerRadius = radius

            // Assert
            #expect(isClose(view.layer.cornerRadius, radius))
            #expect(isClose(view.nz.cornerRadius, radius))
        }

        @Test
        func testWhenMaskedCornersSetShouldWriteAndReadBackSameValue() {
            // Arrange
            let view = TestData.view()
            let corners = TestData.maskedCorners

            // Act
            view.nz.maskedCorners = corners

            // Assert
            #expect(view.layer.maskedCorners == corners)
            #expect(view.nz.maskedCorners == corners)
        }

        @Test
        func testWhenBorderWidthSetShouldWriteAndReadBackSameValue() {
            // Arrange
            let view = TestData.view()
            let width = TestData.borderWidth

            // Act
            view.nz.borderWidth = width

            // Assert
            #expect(isClose(view.layer.borderWidth, width))
            #expect(isClose(view.nz.borderWidth, width))
        }

        @Test
        func testWhenBorderColorSetShouldWriteAndReadBackSameValue() throws {
            // Arrange
            let view = TestData.view()
            let color = TestData.borderColor

            // Act
            view.nz.borderColor = color

            // Assert
            let readBack = try #require(view.nz.borderColor)
            #expect(isClose(readBack.rgbaComponents, color.rgbaComponents))
        }

        @Test
        func testWhenBorderColorClearedShouldReadBackNil() {
            // Arrange
            let view = TestData.view()
            view.nz.borderColor = TestData.borderColor

            // Act
            view.nz.borderColor = nil

            // Assert
            #expect(view.nz.borderColor == nil)
        }

        @Test
        func testWhenShadowColorSetShouldWriteAndReadBackSameValue() throws {
            // Arrange
            let view = TestData.view()
            let color = TestData.shadowColor

            // Act
            view.nz.shadowColor = color

            // Assert
            let readBack = try #require(view.nz.shadowColor)
            #expect(isClose(readBack.rgbaComponents, color.rgbaComponents))
        }

        @Test
        func testWhenShadowAlphaSetShouldWriteAndReadBackSameValue() {
            // Arrange
            let view = TestData.view()
            let alpha = TestData.shadowAlpha

            // Act
            view.nz.shadowAlpha = alpha

            // Assert
            #expect(isClose(view.layer.shadowOpacity, alpha))
            #expect(isClose(view.nz.shadowAlpha, alpha))
        }

        @Test
        func testWhenShadowOffsetSetShouldWriteAndReadBackSameValue() {
            // Arrange
            let view = TestData.view()
            let offset = TestData.shadowOffset

            // Act
            view.nz.shadowOffset = offset

            // Assert
            #expect(isClose(view.layer.shadowOffset, offset))
            #expect(isClose(view.nz.shadowOffset, offset))
        }
    }

    @Suite("Shadow blur conversion")
    @MainActor
    struct ShadowBlurConversion {

        @Test
        func testWhenShadowBlurSetShouldStoreHalfOfItAsLayerRadius() {
            // Arrange
            let view = TestData.view()
            let blur = TestData.shadowBlur

            // Act
            view.nz.shadowBlur = blur

            // Assert
            #expect(isClose(view.layer.shadowRadius, blur / 2))
        }

        @Test
        func testWhenShadowBlurSetShouldReadBackSameValue() {
            // Arrange
            let view = TestData.view()
            let blur = TestData.shadowBlur

            // Act
            view.nz.shadowBlur = blur

            // Assert
            #expect(isClose(view.nz.shadowBlur, blur))
        }
    }

    @Suite("Inspectable properties")
    @MainActor
    struct InspectableProperties {

        @Test
        func testWhenInspectableCornerRadiusSetShouldMatchNamespacedAccessor() {
            // Arrange
            let view = TestData.view()
            let radius = TestData.cornerRadius

            // Act
            view.nz_cornerRadius = radius

            // Assert
            #expect(isClose(view.nz.cornerRadius, radius))
            #expect(isClose(view.nz_cornerRadius, radius))
        }

        @Test
        func testWhenInspectableBorderWidthSetShouldMatchNamespacedAccessor() {
            // Arrange
            let view = TestData.view()
            let width = TestData.borderWidth

            // Act
            view.nz_borderWidth = width

            // Assert
            #expect(isClose(view.nz.borderWidth, width))
            #expect(isClose(view.nz_borderWidth, width))
        }

        @Test
        func testWhenInspectableBorderColorSetShouldMatchNamespacedAccessor() throws {
            // Arrange
            let view = TestData.view()
            let color = TestData.borderColor

            // Act
            view.nz_borderColor = color

            // Assert
            let readBack = try #require(view.nz_borderColor)
            #expect(isClose(readBack.rgbaComponents, color.rgbaComponents))
        }

        @Test
        func testWhenInspectableShadowValuesSetShouldMatchNamespacedAccessors() throws {
            // Arrange
            let view = TestData.view()
            let color = TestData.shadowColor
            let alpha = TestData.shadowAlpha
            let offset = TestData.shadowOffset
            let blur = TestData.shadowBlur

            // Act
            view.nz_shadowColor = color
            view.nz_shadowAlpha = alpha
            view.nz_shadowOffset = offset
            view.nz_shadowBlur = blur

            // Assert
            let readBackColor = try #require(view.nz_shadowColor)
            #expect(isClose(readBackColor.rgbaComponents, color.rgbaComponents))
            #expect(isClose(view.nz_shadowAlpha, alpha))
            #expect(isClose(view.nz_shadowOffset, offset))
            #expect(isClose(view.nz_shadowBlur, blur))
        }
    }
}

#endif
