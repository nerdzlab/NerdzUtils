#if os(iOS)

import UIKit
import Testing

@testable import NerdzUIKit

private enum TestData {

    static let title = "Submit"
    static let replacementTitle = "Retry"
    static let customPadding: CGFloat = 24
    static let defaultPadding: CGFloat = 10
    static let singleInvocation = 1
    static let noInvocations = 0

    @MainActor
    static func button(title: String? = TestData.title) -> LoadableButton {
        let button = LoadableButton(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
        button.setTitle(title, for: .normal)
        return button
    }
}

@Suite("LoadableButton")
@MainActor
struct LoadableButtonTests {

    @Suite("Initial state")
    @MainActor
    struct InitialState {

        @Test
        func testWhenCreatedShouldNotBeLoading() {
            // Arrange
            let button = TestData.button()

            // Act
            let isLoading = button.isLoading

            // Assert
            #expect(isLoading == false)
        }

        @Test
        func testWhenCreatedShouldHideIndicator() {
            // Arrange
            let button = TestData.button()

            // Act
            let isHidden = button.activityIndicatorView.isHidden

            // Assert
            #expect(isHidden)
        }

        @Test
        func testWhenCreatedShouldAddIndicatorAsSubview() {
            // Arrange
            let button = TestData.button()

            // Act
            let superview = button.activityIndicatorView.superview

            // Assert
            #expect(superview === button)
        }

        @Test
        func testWhenCreatedShouldUseDefaultIndicatorPadding() {
            // Arrange
            let button = TestData.button()

            // Act
            let padding = button.topBottomIndicatorPadding

            // Assert
            #expect(isClose(padding, TestData.defaultPadding))
        }
    }

    @Suite("Loading state transitions")
    @MainActor
    struct LoadingStateTransitions {

        @Test
        func testWhenLoadingStartedShouldClearTitle() {
            // Arrange
            let button = TestData.button()

            // Act
            button.isLoading = true

            // Assert
            #expect(button.title(for: .normal) == nil)
        }

        @Test
        func testWhenLoadingStartedShouldRevealIndicator() {
            // Arrange
            let button = TestData.button()

            // Act
            button.isLoading = true

            // Assert
            #expect(button.activityIndicatorView.isHidden == false)
        }

        @Test
        func testWhenLoadingStartedShouldDisableUserInteraction() {
            // Arrange
            let button = TestData.button()

            // Act
            button.isLoading = true

            // Assert
            #expect(button.isUserInteractionEnabled == false)
        }

        @Test
        func testWhenLoadingFinishedShouldRestoreTitle() {
            // Arrange
            let title = TestData.title
            let button = TestData.button(title: title)
            button.isLoading = true

            // Act
            button.isLoading = false

            // Assert
            #expect(button.title(for: .normal) == title)
        }

        @Test
        func testWhenLoadingFinishedShouldRestoreUserInteraction() {
            // Arrange
            let button = TestData.button()
            button.isLoading = true

            // Act
            button.isLoading = false

            // Assert
            #expect(button.isUserInteractionEnabled)
        }

        @Test
        func testWhenTitleChangedWhileLoadingShouldRestoreNewTitle() {
            // Arrange
            let replacement = TestData.replacementTitle
            let button = TestData.button()
            button.isLoading = true

            // Act
            button.setTitle(replacement, for: .normal)
            button.isLoading = false

            // Assert
            #expect(button.title(for: .normal) == replacement)
        }
    }

    @Suite("Loading callbacks")
    @MainActor
    struct LoadingCallbacks {

        @Test
        func testWhenLoadingStartedShouldNotifyStartHandler() {
            // Arrange
            let button = TestData.button()
            let recorder = InvocationRecorder()
            button.onStartLoading = { recorder.record() }

            // Act
            button.isLoading = true

            // Assert
            #expect(recorder.count == TestData.singleInvocation)
        }

        @Test
        func testWhenLoadingFinishedShouldNotifyFinishHandler() {
            // Arrange
            let button = TestData.button()
            let recorder = InvocationRecorder()
            button.isLoading = true
            button.onFinishLoading = { recorder.record() }

            // Act
            button.isLoading = false

            // Assert
            #expect(recorder.count == TestData.singleInvocation)
        }

        @Test
        func testWhenLoadingSetToSameValueShouldNotNotifyHandler() {
            // Arrange
            let button = TestData.button()
            let recorder = InvocationRecorder()
            button.isLoading = true
            button.onStartLoading = { recorder.record() }

            // Act
            button.isLoading = true

            // Assert
            #expect(recorder.count == TestData.noInvocations)
        }
    }

    @Suite("Custom indicator")
    @MainActor
    struct CustomIndicator {

        @Test
        func testWhenCustomIndicatorAssignedShouldBecomeActiveIndicator() {
            // Arrange
            let button = TestData.button()
            let custom = UIView()

            // Act
            button.activityIndicatorView = custom

            // Assert
            #expect(button.activityIndicatorView === custom)
        }

        @Test
        func testWhenCustomIndicatorAssignedShouldDetachPreviousIndicator() {
            // Arrange
            let button = TestData.button()
            let previous = button.activityIndicatorView

            // Act
            button.activityIndicatorView = UIView()

            // Assert
            #expect(previous.superview == nil)
        }

        @Test
        func testWhenCustomIndicatorAssignedShouldFollowLoadingState() {
            // Arrange
            let button = TestData.button()
            let custom = UIView()
            button.activityIndicatorView = custom

            // Act
            button.isLoading = true

            // Assert
            #expect(custom.isHidden == false)
        }
    }
}

#endif
