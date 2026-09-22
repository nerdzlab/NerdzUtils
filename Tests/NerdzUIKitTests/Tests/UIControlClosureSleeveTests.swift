#if os(iOS)

import UIKit
import Testing
import NerdzCore

@testable import NerdzUIKit

private enum TestData {

    static let singleInvocation = 1
    static let event: UIControl.Event = .touchUpInside

    @MainActor
    static func control() -> UIControl {
        UIControl(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    }
}

@Suite("UIControl+ClosureSleeve")
@MainActor
struct UIControlClosureSleeveTests {

    @Suite("Sleeve invocation")
    @MainActor
    struct SleeveInvocation {

        @Test
        func testWhenSleeveInvokedDirectlyShouldRunClosure() {
            // Arrange
            let recorder = InvocationRecorder()
            let sleeve = ClosureSleeve { recorder.record() }

            // Act
            sleeve.invoke()

            // Assert
            #expect(recorder.count == TestData.singleInvocation)
        }
    }

    @Suite("Target registration")
    @MainActor
    struct TargetRegistration {

        @Test
        func testWhenActionAddedShouldRegisterRequestedControlEvent() {
            // Arrange
            let control = TestData.control()
            let event = TestData.event

            // Act
            control.nz.addAction(for: event) { }

            // Assert
            #expect(control.allControlEvents.contains(event))
        }

        @Test
        func testWhenActionAddedShouldKeepSleeveAliveAsTarget() {
            // Arrange
            let control = TestData.control()

            // Act
            control.nz.addAction(for: TestData.event) { }

            // Assert
            #expect(control.allTargets.contains { $0.base is ClosureSleeve })
        }
    }
}

#endif
