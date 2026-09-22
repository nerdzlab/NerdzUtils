#if os(iOS)

import UIKit
import Testing
import NerdzCore

@testable import NerdzUIKit

private enum TestData {

    static let title = "Alert title"
    static let message = "Alert message"
    static let defaultActionTitle = "Default"
    static let destructiveActionTitle = "Destructive"
    static let cancelActionTitle = "Cancel"

    static let screenSize = CGSize(width: 400, height: 800)
    static let alertSize = CGSize(width: 270, height: 144)
    static let sourceSize = CGSize(width: 40, height: 40)

    static let singleInvocation = 1

    @MainActor
    static func alert() -> UIAlertController {
        UIAlertController(title: title, message: message, preferredStyle: .alert)
    }

    @MainActor
    static func actionSheet() -> UIAlertController {
        UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    }

    @MainActor
    static func sourceView() -> UIView {
        UIView(frame: CGRect(origin: .zero, size: sourceSize))
    }
}

@Suite("UIAlertController+EasyBuild")
@MainActor
struct UIAlertControllerEasyBuildTests {

    @Suite("Action building")
    @MainActor
    struct ActionBuilding {

        @Test
        func testWhenDefaultActionAddedShouldAppendActionWithDefaultStyle() throws {
            // Arrange
            let alert = TestData.alert()
            let title = TestData.defaultActionTitle

            // Act
            alert.nz.action(title: title)

            // Assert
            let action = try #require(alert.actions.first)
            #expect(action.title == title)
            #expect(action.style == .default)
        }

        @Test
        func testWhenDestructiveActionAddedShouldAppendActionWithDestructiveStyle() throws {
            // Arrange
            let alert = TestData.alert()
            let title = TestData.destructiveActionTitle

            // Act
            alert.nz.destructive(title: title)

            // Assert
            let action = try #require(alert.actions.first)
            #expect(action.title == title)
            #expect(action.style == .destructive)
        }

        @Test
        func testWhenCancelActionAddedShouldAppendActionWithCancelStyle() throws {
            // Arrange
            let alert = TestData.alert()
            let title = TestData.cancelActionTitle

            // Act
            alert.nz.cancel(title: title)

            // Assert
            let action = try #require(alert.actions.first)
            #expect(action.title == title)
            #expect(action.style == .cancel)
        }

        @Test
        func testWhenActionsChainedShouldPreserveInsertionOrder() {
            // Arrange
            let alert = TestData.alert()
            let expectedTitles = [
                TestData.defaultActionTitle,
                TestData.destructiveActionTitle,
                TestData.cancelActionTitle
            ]

            // Act
            alert.nz.action(title: expectedTitles[0])
                .nz.destructive(title: expectedTitles[1])
                .nz.cancel(title: expectedTitles[2])

            // Assert
            #expect(alert.actions.map(\.title) == expectedTitles)
        }

        @Test
        func testWhenActionAddedShouldReturnSameAlertForChaining() {
            // Arrange
            let alert = TestData.alert()

            // Act
            let returned = alert.nz.action(title: TestData.defaultActionTitle)

            // Assert
            #expect(returned === alert)
        }
    }

    @Suite("Popover source")
    @MainActor
    struct PopoverSource {

        @Test
        func testWhenSourceAssignedShouldConfigurePopoverPresentationController() throws {
            // Arrange
            let sheet = TestData.actionSheet()
            let source = TestData.sourceView()

            // Act
            sheet.nz.source(source)

            // Assert
            let popover = try #require(sheet.popoverPresentationController)
            #expect(popover.sourceView === source)
            #expect(isClose(popover.sourceRect.size, source.bounds.size))
        }
    }

    @Suite("Popover arrow direction")
    @MainActor
    struct PopoverArrowDirection {

        @Test
        func testWhenSourceIsNearLeadingEdgeShouldPointLeft() {
            // Arrange
            let sheet = TestData.actionSheet()
            let position = CGPoint(x: 0, y: TestData.screenSize.height / 2)

            // Act
            let direction = sheet.assignPopoverDirectionBasedUponGivenView(
                sourcePosition: position,
                sourceSize: TestData.sourceSize,
                screenSize: TestData.screenSize,
                alertSize: TestData.alertSize
            )

            // Assert
            #expect(direction == .left)
        }

        @Test
        func testWhenSourceIsNearTrailingEdgeShouldPointRight() {
            // Arrange
            let sheet = TestData.actionSheet()
            let position = CGPoint(x: TestData.screenSize.width, y: TestData.screenSize.height / 2)

            // Act
            let direction = sheet.assignPopoverDirectionBasedUponGivenView(
                sourcePosition: position,
                sourceSize: TestData.sourceSize,
                screenSize: TestData.screenSize,
                alertSize: TestData.alertSize
            )

            // Assert
            #expect(direction == .right)
        }

        @Test
        func testWhenSourceIsNearBottomEdgeShouldPointDown() {
            // Arrange
            let sheet = TestData.actionSheet()
            let position = CGPoint(x: TestData.screenSize.width / 2, y: TestData.screenSize.height)

            // Act
            let direction = sheet.assignPopoverDirectionBasedUponGivenView(
                sourcePosition: position,
                sourceSize: TestData.sourceSize,
                screenSize: TestData.screenSize,
                alertSize: TestData.alertSize
            )

            // Assert
            #expect(direction == .down)
        }

        @Test
        func testWhenSourceIsCenteredShouldPointUp() {
            // Arrange
            let sheet = TestData.actionSheet()
            let position = CGPoint(x: TestData.screenSize.width / 2, y: 0)

            // Act
            let direction = sheet.assignPopoverDirectionBasedUponGivenView(
                sourcePosition: position,
                sourceSize: TestData.sourceSize,
                screenSize: TestData.screenSize,
                alertSize: TestData.alertSize
            )

            // Assert
            #expect(direction == .up)
        }

        @Test
        func testWhenConvenienceOverloadUsedShouldMatchExplicitScreenGeometry() {
            // Arrange
            let sheet = TestData.actionSheet()
            let reference = TestData.actionSheet()
            let position = CGPoint(x: 0, y: 0)

            // Act
            let direction = sheet.assignPopoverDirection(
                sourcePosition: position,
                sourceSize: TestData.sourceSize
            )

            // Assert
            let expected = reference.assignPopoverDirectionBasedUponGivenView(
                sourcePosition: position,
                sourceSize: TestData.sourceSize,
                screenSize: UIScreen.main.bounds.size,
                alertSize: TestData.alertSize
            )
            #expect(direction == expected)
        }
    }

    @Suite("Presentation validation")
    @MainActor
    struct PresentationValidation {

        @Test
        func testWhenAlertHasNoActionsShouldRefusePresentation() {
            // Arrange
            let alert = TestData.alert()
            let presenter = UIViewController()

            // Act
            let didShow = alert.nz.show(on: presenter)

            // Assert
            #expect(didShow == false)
        }

        @Test
        func testWhenAlertHasNoContentShouldRefusePresentation() {
            // Arrange
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            alert.nz.action(title: TestData.defaultActionTitle)
            let presenter = UIViewController()

            // Act
            let didShow = alert.nz.show(on: presenter)

            // Assert
            #expect(didShow == false)
        }

        @Test
        func testWhenAlertIsCompleteShouldAllowPresentation() {
            // Arrange
            let alert = TestData.alert()
            alert.nz.action(title: TestData.defaultActionTitle)
            let presenter = UIViewController()

            // Act
            let didShow = alert.nz.show(on: presenter)

            // Assert
            #expect(didShow)
        }
    }
}

#endif
