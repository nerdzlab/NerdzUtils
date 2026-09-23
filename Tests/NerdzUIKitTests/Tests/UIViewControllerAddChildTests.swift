#if os(iOS)

import UIKit
import Testing
import NerdzCore

@testable import NerdzUIKit

private enum TestData {

    static let fullscreenConstraintsCount = 4
    static let containerFrame = CGRect(x: 0, y: 0, width: 200, height: 200)

    @MainActor
    static func parent() -> UIViewController {
        let controller = UIViewController()
        controller.view.frame = containerFrame
        return controller
    }

    @MainActor
    static func child() -> UIViewController {
        UIViewController()
    }

    @MainActor
    static func container() -> UIView {
        UIView(frame: containerFrame)
    }
}

@Suite("UIViewController+AddChild")
@MainActor
struct UIViewControllerAddChildTests {

    @Suite("Containment relationship")
    @MainActor
    struct ContainmentRelationship {

        @Test
        func testWhenChildAddedShouldBecomeChildOfParent() {
            // Arrange
            let parent = TestData.parent()
            let child = TestData.child()

            // Act
            parent.nz.easilyAddChild(child)

            // Assert
            #expect(parent.children.contains(child))
        }

        @Test
        func testWhenChildAddedShouldReportParentAsItsParent() {
            // Arrange
            let parent = TestData.parent()
            let child = TestData.child()

            // Act
            parent.nz.easilyAddChild(child)

            // Assert
            #expect(child.parent === parent)
        }

        @Test
        func testWhenContainerNotProvidedShouldAddChildViewToParentView() {
            // Arrange
            let parent = TestData.parent()
            let child = TestData.child()

            // Act
            parent.nz.easilyAddChild(child)

            // Assert
            #expect(child.view.superview === parent.view)
        }

        @Test
        func testWhenContainerProvidedShouldAddChildViewToContainer() {
            // Arrange
            let parent = TestData.parent()
            let child = TestData.child()
            let container = TestData.container()
            parent.view.addSubview(container)

            // Act
            parent.nz.easilyAddChild(child, on: container)

            // Assert
            #expect(child.view.superview === container)
        }

        @Test
        func testWhenMultipleChildrenAddedShouldKeepAllOfThem() {
            // Arrange
            let parent = TestData.parent()
            let first = TestData.child()
            let second = TestData.child()
            let expectedCount = 2

            // Act
            parent.nz.easilyAddChild(first)
            parent.nz.easilyAddChild(second)

            // Assert
            #expect(parent.children.count == expectedCount)
        }
    }

    @Suite("Layout configuration")
    @MainActor
    struct LayoutConfiguration {

        @Test
        func testWhenChildAddedShouldDisableAutoresizingMaskTranslation() {
            // Arrange
            let parent = TestData.parent()
            let child = TestData.child()

            // Act
            parent.nz.easilyAddChild(child)

            // Assert
            #expect(child.view.translatesAutoresizingMaskIntoConstraints == false)
        }

        @Test
        func testWhenDefaultConfigurationUsedShouldPinChildToAllContainerEdges() {
            // Arrange
            let parent = TestData.parent()
            let child = TestData.child()
            let container = TestData.container()
            parent.view.addSubview(container)
            let expectedCount = TestData.fullscreenConstraintsCount

            // Act
            parent.nz.easilyAddChild(child, on: container)

            // Assert
            #expect(container.constraints.count == expectedCount)
            #expect(container.constraints.allSatisfy { $0.isActive })
        }

        @Test
        func testWhenCustomConfigurationProvidedShouldUseItInsteadOfDefault() {
            // Arrange
            let parent = TestData.parent()
            let child = TestData.child()
            let container = TestData.container()
            parent.view.addSubview(container)
            let recorder = InvocationRecorder()
            let expectedInvocations = 1

            // Act
            parent.nz.easilyAddChild(child, on: container) { _, _ in
                recorder.record()
            }

            // Assert
            #expect(recorder.count == expectedInvocations)
            #expect(container.constraints.isEmpty)
        }

        @Test
        func testWhenCustomConfigurationProvidedShouldReceiveChildViewAndContainer() {
            // Arrange
            let parent = TestData.parent()
            let child = TestData.child()
            let container = TestData.container()
            parent.view.addSubview(container)
            var receivedChildView: UIView?
            var receivedContainer: UIView?

            // Act
            parent.nz.easilyAddChild(child, on: container) { childView, parentView in
                receivedChildView = childView
                receivedContainer = parentView
            }

            // Assert
            #expect(receivedChildView === child.view)
            #expect(receivedContainer === container)
        }

        @Test
        func testWhenFullscreenSetupAppliedDirectlyShouldActivateAllEdgeConstraints() {
            // Arrange
            let container = TestData.container()
            let childView = UIView()
            childView.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(childView)
            let expectedCount = TestData.fullscreenConstraintsCount

            // Act
            UIViewController.nz.setupFullscreen(childView, on: container)

            // Assert
            #expect(container.constraints.count == expectedCount)
        }
    }
}

#endif
