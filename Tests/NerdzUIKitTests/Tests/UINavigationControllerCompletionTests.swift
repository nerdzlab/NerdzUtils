//
//  UINavigationControllerCompletionTests.swift
//  NerdzUIKitTests
//

#if os(iOS)

import Testing
import UIKit
@testable import NerdzUIKit

@Suite("UINavigationController+Completion")
@MainActor
struct UINavigationControllerCompletionTests {

    @Suite("Without an animated transition")
    @MainActor
    struct WithoutAnimatedTransition {

        @Test
        func testWhenPushedWithoutAnimationShouldRunCompletion() {
            // Arrange
            let navigation = TestData.createNavigation()
            let recorder = InvocationRecorder()

            // Act
            navigation.nz.pushViewController(TestData.createController(), animated: false) {
                recorder.record()
            }

            // Assert
            #expect(recorder.count == TestData.singleInvocation)
        }

        @Test
        func testWhenPushedWithoutAnimationShouldChangeTheStack() {
            // Arrange
            let navigation = TestData.createNavigation()
            let pushed = TestData.createController()

            // Act
            navigation.nz.pushViewController(pushed, animated: false, completion: nil)

            // Assert
            #expect(navigation.viewControllers.last === pushed)
        }

        @Test
        func testWhenPoppedWithoutAnimationShouldRunCompletion() {
            // Arrange
            let navigation = TestData.createNavigation()
            let recorder = InvocationRecorder()

            navigation.nz.pushViewController(TestData.createController(), animated: false, completion: nil)

            // Act
            navigation.nz.popViewController(animated: false) {
                recorder.record()
            }

            // Assert
            #expect(recorder.count == TestData.singleInvocation)
        }

        @Test
        func testWhenPoppedToRootWithoutAnimationShouldRunCompletion() {
            // Arrange
            let navigation = TestData.createNavigation()
            let recorder = InvocationRecorder()

            navigation.nz.pushViewController(TestData.createController(), animated: false, completion: nil)

            // Act
            navigation.nz.popToRootViewController(animated: false) {
                recorder.record()
            }

            // Assert
            #expect(recorder.count == TestData.singleInvocation)
        }

        @Test
        func testWhenPoppedToControllerWithoutAnimationShouldRunCompletion() {
            // Arrange
            let root = TestData.createController()
            let navigation = UINavigationController(rootViewController: root)
            let recorder = InvocationRecorder()

            navigation.nz.pushViewController(TestData.createController(), animated: false, completion: nil)

            // Act
            navigation.nz.popToViewController(root, animated: false) {
                recorder.record()
            }

            // Assert
            #expect(recorder.count == TestData.singleInvocation)
        }
    }

    @Suite("Without a completion")
    @MainActor
    struct WithoutCompletion {

        @Test
        func testWhenNoCompletionProvidedShouldStillChangeTheStack() {
            // Arrange
            let navigation = TestData.createNavigation()
            let pushed = TestData.createController()

            // Act
            navigation.nz.pushViewController(pushed, animated: true, completion: nil)

            // Assert
            #expect(navigation.viewControllers.contains(pushed))
        }
    }
}

// MARK: - Test data

private enum TestData {
    static let singleInvocation = 1

    static func createController() -> UIViewController {
        UIViewController()
    }

    static func createNavigation() -> UINavigationController {
        UINavigationController(rootViewController: createController())
    }
}

#endif
