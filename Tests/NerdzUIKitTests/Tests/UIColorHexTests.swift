#if os(iOS)

import UIKit
import Testing

@testable import NerdzUIKit

private enum TestData {

    static let redChannel = 0xFF
    static let greenChannel = 0x88
    static let blueChannel = 0x33

    static let customAlpha: CGFloat = 0.42
    static let opaqueAlpha: CGFloat = 1

    static let invalidHex = "not-a-color"
    static let shortHex = "FFF"

    static func hex(prefixed: Bool) -> String {
        UIColor.hexString(red8Bit: redChannel, green8Bit: greenChannel, blue8Bit: blueChannel, prefixed: prefixed)
    }

    static func expectedComponents(alpha: CGFloat) -> RGBAComponents {
        RGBAComponents(red8Bit: redChannel, green8Bit: greenChannel, blue8Bit: blueChannel, alpha: alpha)
    }

    static var blackComponents: RGBAComponents {
        RGBAComponents(red8Bit: 0, green8Bit: 0, blue8Bit: 0, alpha: opaqueAlpha)
    }
}

@Suite("UIColor+HEX")
struct UIColorHexTests {

    @Suite("Parsing")
    struct Parsing {

        @Test
        func testWhenPrefixedHexProvidedShouldProduceMatchingComponents() {
            // Arrange
            let hex = TestData.hex(prefixed: true)
            let expected = TestData.expectedComponents(alpha: TestData.opaqueAlpha)

            // Act
            let color = UIColor(hex: hex)

            // Assert
            #expect(isClose(color.rgbaComponents, expected))
        }

        @Test
        func testWhenUnprefixedHexProvidedShouldProduceMatchingComponents() {
            // Arrange
            let hex = TestData.hex(prefixed: false)
            let expected = TestData.expectedComponents(alpha: TestData.opaqueAlpha)

            // Act
            let color = UIColor(hex: hex)

            // Assert
            #expect(isClose(color.rgbaComponents, expected))
        }

        @Test
        func testWhenPrefixVariantsDifferShouldProduceEqualColors() {
            // Arrange
            let prefixed = TestData.hex(prefixed: true)
            let unprefixed = TestData.hex(prefixed: false)

            // Act
            let prefixedColor = UIColor(hex: prefixed)
            let unprefixedColor = UIColor(hex: unprefixed)

            // Assert
            #expect(isClose(prefixedColor.rgbaComponents, unprefixedColor.rgbaComponents))
        }

        @Test
        func testWhenHexIsInvalidShouldFallBackToBlack() {
            // Arrange
            let hex = TestData.invalidHex

            // Act
            let color = UIColor(hex: hex)

            // Assert
            #expect(isClose(color.rgbaComponents, TestData.blackComponents))
        }

        @Test
        func testWhenHexIsEmptyShouldFallBackToBlack() {
            // Arrange
            let hex = ""

            // Act
            let color = UIColor(hex: hex)

            // Assert
            #expect(isClose(color.rgbaComponents, TestData.blackComponents))
        }

        @Test
        func testWhenShortHexProvidedShouldNotExpandToFullNotation() {
            // Arrange
            let hex = TestData.shortHex
            let expanded = UIColor(hex: TestData.shortHex + TestData.shortHex)

            // Act
            let color = UIColor(hex: hex)

            // Assert
            #expect(isClose(color.rgbaComponents, expanded.rgbaComponents) == false)
        }
    }

    @Suite("Alpha")
    struct Alpha {

        @Test
        func testWhenAlphaNotProvidedShouldBeFullyOpaque() {
            // Arrange
            let hex = TestData.hex(prefixed: true)

            // Act
            let color = UIColor(hex: hex)

            // Assert
            #expect(isClose(color.rgbaComponents.alpha, 1))
        }

        @Test
        func testWhenAlphaProvidedShouldBeApplied() {
            // Arrange
            let hex = TestData.hex(prefixed: true)
            let alpha = TestData.customAlpha

            // Act
            let color = UIColor(hex: hex, alpha: alpha)

            // Assert
            #expect(isClose(color.rgbaComponents.alpha, alpha))
        }

        @Test
        func testWhenAlphaProvidedShouldNotAffectColorChannels() {
            // Arrange
            let hex = TestData.hex(prefixed: true)
            let expected = TestData.expectedComponents(alpha: TestData.customAlpha)

            // Act
            let color = UIColor(hex: hex, alpha: TestData.customAlpha)

            // Assert
            #expect(isClose(color.rgbaComponents, expected))
        }
    }

    @Suite("Round trip")
    struct RoundTrip {

        @Test(arguments: [0x00, 0x01, 0x7F, 0x80, 0xFE, 0xFF])
        func testWhenChannelValueEncodedShouldDecodeToSameValue(channel: Int) {
            // Arrange
            let hex = UIColor.hexString(red8Bit: channel, green8Bit: channel, blue8Bit: channel, prefixed: true)
            let expected = RGBAComponents(
                red8Bit: channel,
                green8Bit: channel,
                blue8Bit: channel,
                alpha: TestData.opaqueAlpha
            )

            // Act
            let color = UIColor(hex: hex)

            // Assert
            #expect(isClose(color.rgbaComponents, expected))
        }

        @Test
        func testWhenChannelsDifferShouldMapToCorrectPositions() {
            // Arrange
            let red = 0x12
            let green = 0x34
            let blue = 0x56
            let hex = UIColor.hexString(red8Bit: red, green8Bit: green, blue8Bit: blue, prefixed: true)
            let expected = RGBAComponents(
                red8Bit: red,
                green8Bit: green,
                blue8Bit: blue,
                alpha: TestData.opaqueAlpha
            )

            // Act
            let color = UIColor(hex: hex)

            // Assert
            #expect(isClose(color.rgbaComponents, expected))
        }
    }
}

#endif
