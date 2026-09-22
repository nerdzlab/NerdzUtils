#if os(iOS)

import UIKit
import Testing
import NerdzCore

@testable import NerdzUIKit

private enum TestData {

    static let frame = CGRect(x: 0, y: 0, width: 120, height: 60)
    static let colors: [UIColor] = [.red, .blue]
    static let locations: [NSNumber] = [0, 1]
    static let startPoint = CGPoint(x: 0, y: 0)
    static let endPoint = CGPoint(x: 1, y: 1)
    static let type: CAGradientLayerType = .radial

    @MainActor
    static func view() -> UIView {
        UIView(frame: frame)
    }
}

@Suite("UIView+ApplyGradient")
@MainActor
struct UIViewApplyGradientTests {

    @Test
    func testWhenGradientAppliedShouldInsertLayerAtBottom() {
        // Arrange
        let view = TestData.view()

        // Act
        let gradient = view.nz.applyGradient(colors: TestData.colors, locations: TestData.locations)

        // Assert
        #expect(view.layer.sublayers?.first === gradient)
    }

    @Test
    func testWhenGradientAppliedShouldUseViewBoundsAsFrame() {
        // Arrange
        let view = TestData.view()
        let expectedBounds = view.bounds

        // Act
        let gradient = view.nz.applyGradient(colors: TestData.colors, locations: TestData.locations)

        // Assert
        #expect(isClose(gradient.frame.size, expectedBounds.size))
    }

    @Test
    func testWhenGradientAppliedShouldMapColorsToCoreGraphicsColors() {
        // Arrange
        let view = TestData.view()
        let colors = TestData.colors

        // Act
        let gradient = view.nz.applyGradient(colors: colors, locations: TestData.locations)

        // Assert
        let applied = (gradient.colors as? [CGColor]) ?? []
        #expect(applied.count == colors.count)
        #expect(zip(applied, colors).allSatisfy { isClose(UIColor(cgColor: $0).rgbaComponents, $1.rgbaComponents) })
    }

    @Test
    func testWhenGradientAppliedShouldKeepProvidedLocations() {
        // Arrange
        let view = TestData.view()
        let locations = TestData.locations

        // Act
        let gradient = view.nz.applyGradient(colors: TestData.colors, locations: locations)

        // Assert
        #expect(gradient.locations == locations)
    }

    @Test
    func testWhenCustomGeometryProvidedShouldApplyItToLayer() {
        // Arrange
        let view = TestData.view()
        let start = TestData.startPoint
        let end = TestData.endPoint
        let type = TestData.type

        // Act
        let gradient = view.nz.applyGradient(
            colors: TestData.colors,
            locations: TestData.locations,
            type: type,
            startPoint: start,
            endPoint: end
        )

        // Assert
        #expect(gradient.type == type)
        #expect(isClose(gradient.startPoint, start))
        #expect(isClose(gradient.endPoint, end))
    }

    @Test
    func testWhenGeometryOmittedShouldUseVerticalDefaults() {
        // Arrange
        let view = TestData.view()

        // Act
        let gradient = view.nz.applyGradient(colors: TestData.colors, locations: TestData.locations)

        // Assert
        #expect(gradient.type == .axial)
        #expect(isClose(gradient.startPoint, CGPoint(x: 0.5, y: 0)))
        #expect(isClose(gradient.endPoint, CGPoint(x: 0.5, y: 1)))
    }
}

#endif
