#if os(iOS)

import UIKit
import Testing

@testable import NerdzUIKit

fileprivate struct HexExpansion: Sendable {
    let shorthand: String
    let red: Int
    let green: Int
    let blue: Int
    let alpha: Int
}

private enum TestData {

    static let redChannel = 0xFF
    static let greenChannel = 0x88
    static let blueChannel = 0x33
    static let embeddedAlphaChannel = 0x80

    static let customAlpha: CGFloat = 0.42
    static let opaqueAlpha: CGFloat = 1

    static let invalidHex = "not-a-color"
    static let emptyHex = ""
    static let unsupportedLengths = ["1", "12", "12345", "1234567", "123456789"]
    static let fallbackColor = UIColor.magenta

    static let opaqueChannel = 0xFF

    static let shorthandExpansions: [HexExpansion] = [
        HexExpansion(shorthand: "FFF", red: 0xFF, green: 0xFF, blue: 0xFF, alpha: opaqueChannel),
        HexExpansion(shorthand: "ABC", red: 0xAA, green: 0xBB, blue: 0xCC, alpha: opaqueChannel),
        HexExpansion(shorthand: "000", red: 0x00, green: 0x00, blue: 0x00, alpha: opaqueChannel),
        HexExpansion(shorthand: "1a5", red: 0x11, green: 0xAA, blue: 0x55, alpha: opaqueChannel)
    ]

    static let shorthandAlphaExpansions: [HexExpansion] = [
        HexExpansion(shorthand: "ABCD", red: 0xAA, green: 0xBB, blue: 0xCC, alpha: 0xDD),
        HexExpansion(shorthand: "0009", red: 0x00, green: 0x00, blue: 0x00, alpha: 0x99)
    ]

    static func hex(prefixed: Bool) -> String {
        UIColor.hexString(red8Bit: redChannel, green8Bit: greenChannel, blue8Bit: blueChannel, prefixed: prefixed)
    }

    static func hexWithAlpha(prefixed: Bool) -> String {
        UIColor.hexString(
            red8Bit: redChannel,
            green8Bit: greenChannel,
            blue8Bit: blueChannel,
            alpha8Bit: embeddedAlphaChannel,
            prefixed: prefixed
        )
    }

    static func expectedComponents(alpha: CGFloat) -> RGBAComponents {
        RGBAComponents(red8Bit: redChannel, green8Bit: greenChannel, blue8Bit: blueChannel, alpha: alpha)
    }

    static var expectedComponentsWithEmbeddedAlpha: RGBAComponents {
        RGBAComponents(
            red8Bit: redChannel,
            green8Bit: greenChannel,
            blue8Bit: blueChannel,
            alpha8Bit: embeddedAlphaChannel
        )
    }
}

@Suite("UIColor+HEX")
struct UIColorHexTests {

    @Suite("Parsing")
    struct Parsing {

        @Test
        func testWhenPrefixedHexProvidedShouldProduceMatchingComponents() throws {
            // Arrange
            let hex = TestData.hex(prefixed: true)
            let expected = TestData.expectedComponents(alpha: TestData.opaqueAlpha)

            // Act
            let color = try #require(UIColor(hex: hex))

            // Assert
            #expect(isClose(color.rgbaComponents, expected))
        }

        @Test
        func testWhenUnprefixedHexProvidedShouldProduceMatchingComponents() throws {
            // Arrange
            let hex = TestData.hex(prefixed: false)
            let expected = TestData.expectedComponents(alpha: TestData.opaqueAlpha)

            // Act
            let color = try #require(UIColor(hex: hex))

            // Assert
            #expect(isClose(color.rgbaComponents, expected))
        }

        @Test
        func testWhenPrefixVariantsDifferShouldProduceEqualColors() throws {
            // Arrange
            let prefixed = TestData.hex(prefixed: true)
            let unprefixed = TestData.hex(prefixed: false)

            // Act
            let prefixedColor = try #require(UIColor(hex: prefixed))
            let unprefixedColor = try #require(UIColor(hex: unprefixed))

            // Assert
            #expect(isClose(prefixedColor.rgbaComponents, unprefixedColor.rgbaComponents))
        }

        @Test
        func testWhenHexIsSurroundedByWhitespaceShouldProduceSameColorAsTrimmed() throws {
            // Arrange
            let hex = TestData.hex(prefixed: true)
            let padded = "  \n\(hex)\t "

            // Act
            let paddedColor = try #require(UIColor(hex: padded))
            let trimmedColor = try #require(UIColor(hex: hex))

            // Assert
            #expect(isClose(paddedColor.rgbaComponents, trimmedColor.rgbaComponents))
        }

        @Test
        func testWhenHexIsLowercasedShouldProduceSameColorAsUppercased() throws {
            // Arrange
            let hex = TestData.hex(prefixed: true)

            // Act
            let lowercasedColor = try #require(UIColor(hex: hex.lowercased()))
            let uppercasedColor = try #require(UIColor(hex: hex.uppercased()))

            // Assert
            #expect(isClose(lowercasedColor.rgbaComponents, uppercasedColor.rgbaComponents))
        }

        @Test
        func testWhenHexIsInvalidShouldReturnNil() {
            // Arrange
            let hex = TestData.invalidHex

            // Act
            let color = UIColor(hex: hex)

            // Assert
            #expect(color == nil)
        }

        @Test
        func testWhenHexIsEmptyShouldReturnNil() {
            // Arrange
            let hex = TestData.emptyHex

            // Act
            let color = UIColor(hex: hex)

            // Assert
            #expect(color == nil)
        }

        @Test(arguments: TestData.unsupportedLengths)
        func testWhenHexLengthIsUnsupportedShouldReturnNil(hex: String) {
            // Arrange
            let candidate = hex

            // Act
            let color = UIColor(hex: candidate)

            // Assert
            #expect(color == nil)
        }
    }

    @Suite("Shorthand notation")
    struct Shorthand {

        @Test(arguments: TestData.shorthandExpansions)
        fileprivate func testWhenShorthandHexProvidedShouldExpandEachDigit(expansion: HexExpansion) throws {
            // Arrange
            let expected = RGBAComponents(
                red8Bit: expansion.red,
                green8Bit: expansion.green,
                blue8Bit: expansion.blue,
                alpha8Bit: expansion.alpha
            )

            // Act
            let color = try #require(UIColor(hex: expansion.shorthand))

            // Assert
            #expect(isClose(color.rgbaComponents, expected))
        }

        @Test(arguments: TestData.shorthandAlphaExpansions)
        fileprivate func testWhenShorthandAlphaHexProvidedShouldExpandEachDigit(expansion: HexExpansion) throws {
            // Arrange
            let expected = RGBAComponents(
                red8Bit: expansion.red,
                green8Bit: expansion.green,
                blue8Bit: expansion.blue,
                alpha8Bit: expansion.alpha
            )

            // Act
            let color = try #require(UIColor(hex: expansion.shorthand))

            // Assert
            #expect(isClose(color.rgbaComponents, expected))
        }

        @Test(arguments: TestData.shorthandExpansions)
        fileprivate func testWhenShorthandIsPrefixedShouldProduceSameColorAsUnprefixed(expansion: HexExpansion) throws {
            // Arrange
            let shorthand = expansion.shorthand

            // Act
            let prefixedColor = try #require(UIColor(hex: "#\(shorthand)"))
            let unprefixedColor = try #require(UIColor(hex: shorthand))

            // Assert
            #expect(isClose(prefixedColor.rgbaComponents, unprefixedColor.rgbaComponents))
        }
    }

    @Suite("Alpha")
    struct Alpha {

        @Test
        func testWhenAlphaNotProvidedShouldBeFullyOpaque() throws {
            // Arrange
            let hex = TestData.hex(prefixed: true)

            // Act
            let color = try #require(UIColor(hex: hex))

            // Assert
            #expect(isClose(color.rgbaComponents.alpha, TestData.opaqueAlpha))
        }

        @Test
        func testWhenAlphaProvidedShouldBeApplied() throws {
            // Arrange
            let hex = TestData.hex(prefixed: true)
            let alpha = TestData.customAlpha

            // Act
            let color = try #require(UIColor(hex: hex, alpha: alpha))

            // Assert
            #expect(isClose(color.rgbaComponents.alpha, alpha))
        }

        @Test
        func testWhenAlphaProvidedShouldNotAffectColorChannels() throws {
            // Arrange
            let hex = TestData.hex(prefixed: true)
            let expected = TestData.expectedComponents(alpha: TestData.customAlpha)

            // Act
            let color = try #require(UIColor(hex: hex, alpha: TestData.customAlpha))

            // Assert
            #expect(isClose(color.rgbaComponents, expected))
        }

        @Test
        func testWhenHexCarriesAlphaShouldUseEmbeddedAlpha() throws {
            // Arrange
            let hex = TestData.hexWithAlpha(prefixed: true)
            let expected = TestData.expectedComponentsWithEmbeddedAlpha

            // Act
            let color = try #require(UIColor(hex: hex))

            // Assert
            #expect(isClose(color.rgbaComponents, expected))
        }

        @Test
        func testWhenHexCarriesAlphaAndAlphaProvidedShouldPreferProvidedAlpha() throws {
            // Arrange
            let hex = TestData.hexWithAlpha(prefixed: true)
            let expected = TestData.expectedComponents(alpha: TestData.customAlpha)

            // Act
            let color = try #require(UIColor(hex: hex, alpha: TestData.customAlpha))

            // Assert
            #expect(isClose(color.rgbaComponents, expected))
        }

        @Test
        func testWhenHexCarriesAlphaShouldMapColorChannelsToSamePositionsAsSixDigitNotation() throws {
            // Arrange
            let sixDigitHex = TestData.hex(prefixed: true)
            let eightDigitHex = TestData.hexWithAlpha(prefixed: true)

            // Act
            let sixDigitColor = try #require(UIColor(hex: sixDigitHex, alpha: TestData.opaqueAlpha))
            let eightDigitColor = try #require(UIColor(hex: eightDigitHex, alpha: TestData.opaqueAlpha))

            // Assert
            #expect(isClose(sixDigitColor.rgbaComponents, eightDigitColor.rgbaComponents))
        }
    }

    @Suite("Fallback")
    struct Fallback {

        @Test
        func testWhenHexIsInvalidShouldReturnProvidedFallback() {
            // Arrange
            let fallback = TestData.fallbackColor

            // Act
            let color = UIColor.hex(TestData.invalidHex, fallback: fallback)

            // Assert
            #expect(isClose(color.rgbaComponents, fallback.rgbaComponents))
        }

        @Test
        func testWhenFallbackNotProvidedShouldFallBackToBlack() {
            // Arrange
            let expected = UIColor.black

            // Act
            let color = UIColor.hex(TestData.invalidHex)

            // Assert
            #expect(isClose(color.rgbaComponents, expected.rgbaComponents))
        }

        @Test
        func testWhenHexIsValidShouldIgnoreFallback() {
            // Arrange
            let hex = TestData.hex(prefixed: true)
            let expected = TestData.expectedComponents(alpha: TestData.opaqueAlpha)

            // Act
            let color = UIColor.hex(hex, fallback: TestData.fallbackColor)

            // Assert
            #expect(isClose(color.rgbaComponents, expected))
        }
    }

    @Suite("Round trip")
    struct RoundTrip {

        @Test(arguments: [0x00, 0x01, 0x7F, 0x80, 0xFE, 0xFF])
        func testWhenChannelValueEncodedShouldDecodeToSameValue(channel: Int) throws {
            // Arrange
            let hex = UIColor.hexString(red8Bit: channel, green8Bit: channel, blue8Bit: channel, prefixed: true)
            let expected = RGBAComponents(
                red8Bit: channel,
                green8Bit: channel,
                blue8Bit: channel,
                alpha: TestData.opaqueAlpha
            )

            // Act
            let color = try #require(UIColor(hex: hex))

            // Assert
            #expect(isClose(color.rgbaComponents, expected))
        }

        @Test(arguments: [0x00, 0x01, 0x7F, 0x80, 0xFE, 0xFF])
        func testWhenAlphaChannelEncodedShouldDecodeToSameValue(channel: Int) throws {
            // Arrange
            let hex = UIColor.hexString(
                red8Bit: TestData.redChannel,
                green8Bit: TestData.greenChannel,
                blue8Bit: TestData.blueChannel,
                alpha8Bit: channel,
                prefixed: true
            )
            let expected = RGBAComponents(
                red8Bit: TestData.redChannel,
                green8Bit: TestData.greenChannel,
                blue8Bit: TestData.blueChannel,
                alpha8Bit: channel
            )

            // Act
            let color = try #require(UIColor(hex: hex))

            // Assert
            #expect(isClose(color.rgbaComponents, expected))
        }

        @Test
        func testWhenChannelsDifferShouldMapToCorrectPositions() throws {
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
            let color = try #require(UIColor(hex: hex))

            // Assert
            #expect(isClose(color.rgbaComponents, expected))
        }
    }
}

#endif
