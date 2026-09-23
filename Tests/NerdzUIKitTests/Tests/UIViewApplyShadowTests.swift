#if os(iOS)

import UIKit
import Testing
import NerdzCore

@testable import NerdzUIKit

private enum TestData {

    static let color: UIColor = .green
    static let opacity: Float = 0.3
    static let offset = CGSize(width: 4, height: -2)
    static let radius: CGFloat = 8

    @MainActor
    static func view() -> UIView {
        UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    }
}

@Suite("UIView+ApplyShadow")
@MainActor
struct UIViewApplyShadowTests {

    @Test
    func testWhenShadowAppliedShouldSetColorOnLayer() throws {
        // Arrange
        let view = TestData.view()
        let color = TestData.color

        // Act
        view.nz.applyShadow(color: color)

        // Assert
        let layerColor = UIColor(cgColor: try #require(view.layer.shadowColor))
        #expect(isClose(layerColor.rgbaComponents, color.rgbaComponents))
    }

    @Test
    func testWhenShadowAppliedWithAllParametersShouldSetThemOnLayer() {
        // Arrange
        let view = TestData.view()
        let opacity = TestData.opacity
        let offset = TestData.offset
        let radius = TestData.radius

        // Act
        view.nz.applyShadow(color: TestData.color, opacity: opacity, offSet: offset, radius: radius)

        // Assert
        #expect(isClose(view.layer.shadowOpacity, opacity))
        #expect(isClose(view.layer.shadowOffset, offset))
        #expect(isClose(view.layer.shadowRadius, radius))
    }

    @Test
    func testWhenOptionalParametersOmittedShouldUseDocumentedDefaults() {
        // Arrange
        let view = TestData.view()

        // Act
        view.nz.applyShadow(color: TestData.color)

        // Assert
        #expect(isClose(view.layer.shadowOpacity, 0.5))
        #expect(isClose(view.layer.shadowOffset, .zero))
        #expect(isClose(view.layer.shadowRadius, 1))
    }
}

#endif
