#if os(iOS)

import UIKit
import Testing
import NerdzCore

@testable import NerdzUIKit

private enum TestData {

    static let frame = CGRect(x: 0, y: 0, width: 150, height: 90)
    static let strokeColor: UIColor = .orange
    static let fillColor: UIColor = .purple
    static let position = CGPoint(x: 5, y: 7)
    static let lineWidth: CGFloat = 4
    static let lineJoin: CAShapeLayerLineJoin = .bevel
    static let lineDashPattern: [NSNumber] = [2, 8]
    static let cornerRadius: CGFloat = 6

    @MainActor
    static func view() -> UIView {
        UIView(frame: frame)
    }
}

@Suite("UIView+AddDashedBorder")
@MainActor
struct UIViewAddDashedBorderTests {

    @Test
    func testWhenBorderAddedShouldAttachShapeLayerToView() {
        // Arrange
        let view = TestData.view()

        // Act
        let shapeLayer = view.nz.addDashedBorder(with: TestData.strokeColor)

        // Assert
        #expect(view.layer.sublayers?.contains(shapeLayer) == true)
    }

    @Test
    func testWhenBorderAddedShouldUseViewBoundsForLayer() {
        // Arrange
        let view = TestData.view()
        let expectedSize = view.bounds.size

        // Act
        let shapeLayer = view.nz.addDashedBorder(with: TestData.strokeColor)

        // Assert
        #expect(isClose(shapeLayer.bounds.size, expectedSize))
    }

    @Test
    func testWhenStrokeColorProvidedShouldApplyItToLayer() throws {
        // Arrange
        let view = TestData.view()
        let color = TestData.strokeColor

        // Act
        let shapeLayer = view.nz.addDashedBorder(with: color)

        // Assert
        let applied = UIColor(cgColor: try #require(shapeLayer.strokeColor))
        #expect(isClose(applied.rgbaComponents, color.rgbaComponents))
    }

    @Test
    func testWhenCustomParametersProvidedShouldApplyThemToLayer() throws {
        // Arrange
        let view = TestData.view()
        let fillColor = TestData.fillColor
        let position = TestData.position
        let lineWidth = TestData.lineWidth
        let lineJoin = TestData.lineJoin
        let dashPattern = TestData.lineDashPattern

        // Act
        let shapeLayer = view.nz.addDashedBorder(
            with: TestData.strokeColor,
            fillColor: fillColor,
            position: position,
            lineWidth: lineWidth,
            lineJoin: lineJoin,
            lineDashPattern: dashPattern,
            cornerRadius: TestData.cornerRadius
        )

        // Assert
        let appliedFill = UIColor(cgColor: try #require(shapeLayer.fillColor))
        #expect(isClose(appliedFill.rgbaComponents, fillColor.rgbaComponents))
        #expect(isClose(shapeLayer.position, position))
        #expect(isClose(shapeLayer.lineWidth, lineWidth))
        #expect(shapeLayer.lineJoin == lineJoin)
        #expect(shapeLayer.lineDashPattern == dashPattern)
    }

    @Test
    func testWhenParametersOmittedShouldUseDocumentedDefaults() throws {
        // Arrange
        let view = TestData.view()

        // Act
        let shapeLayer = view.nz.addDashedBorder(with: TestData.strokeColor)

        // Assert
        let appliedFill = UIColor(cgColor: try #require(shapeLayer.fillColor))
        #expect(isClose(appliedFill.rgbaComponents, UIColor.clear.rgbaComponents))
        #expect(isClose(shapeLayer.lineWidth, 2))
        #expect(shapeLayer.lineJoin == .round)
        #expect(shapeLayer.lineDashPattern == [6, 3])
    }

    @Test
    func testWhenBorderAddedShouldBuildPathCoveringViewBounds() throws {
        // Arrange
        let view = TestData.view()
        let expectedBounds = view.bounds

        // Act
        let shapeLayer = view.nz.addDashedBorder(with: TestData.strokeColor)

        // Assert
        let path = try #require(shapeLayer.path)
        #expect(isClose(path.boundingBoxOfPath.size, expectedBounds.size, tolerance: Tolerance.dimension))
    }
}

#endif
