#if os(iOS)

import UIKit
import Testing
import NerdzCore

@testable import NerdzUIKit

private enum TestData {

    static let singleInvocation = 1
    static let event: UIControl.Event = .touchUpInside
    static let distinctEvents: [UIControl.Event] = [.touchUpInside, .valueChanged, .editingChanged]

    @MainActor
    static func control() -> UIControl {
        UIControl(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    }

    @MainActor
    static func sleeves(of control: UIControl) -> [ClosureSleeve] {
        control.allTargets.compactMap({ $0.base as? ClosureSleeve })
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

        @Test
        func testWhenRegisteredSleeveInvokedShouldRunClosure() {
            // Arrange
            let recorder = InvocationRecorder()
            let control = TestData.control()
            control.nz.addAction(for: TestData.event) { recorder.record() }

            // Act
            TestData.sleeves(of: control).forEach({ $0.invoke() })

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
            #expect(control.allTargets.contains(where: { $0.base is ClosureSleeve }))
        }

        @Test
        func testWhenActionAddedShouldRegisterSleeveActionForRequestedEvent() {
            // Arrange
            let control = TestData.control()
            let event = TestData.event

            // Act
            control.nz.addAction(for: event) { }

            // Assert
            let registeredActions = TestData.sleeves(of: control)
                .compactMap({ control.actions(forTarget: $0, forControlEvent: event) })
                .flatMap({ $0 })

            #expect(registeredActions.isEmpty == false)
        }
    }

    @Suite("Multiple actions")
    @MainActor
    struct MultipleActions {

        @Test
        func testWhenActionsAddedForDifferentEventsShouldKeepEverySleeveAlive() {
            // Arrange
            let control = TestData.control()
            let events = TestData.distinctEvents

            // Act
            for event in events {
                control.nz.addAction(for: event) { }
            }

            // Assert
            #expect(TestData.sleeves(of: control).count == events.count)
        }

        @Test
        func testWhenActionsAddedForDifferentEventsShouldRegisterEveryEvent() {
            // Arrange
            let control = TestData.control()
            let events = TestData.distinctEvents

            // Act
            for event in events {
                control.nz.addAction(for: event) { }
            }

            // Assert
            let coveredEvents = events.filter { event in
                TestData.sleeves(of: control).contains(where: {
                    control.actions(forTarget: $0, forControlEvent: event)?.isEmpty == false
                })
            }

            #expect(coveredEvents.count == events.count)
        }

        @Test
        func testWhenActionsAddedForSameEventShouldKeepEverySleeveAlive() {
            // Arrange
            let control = TestData.control()
            let event = TestData.event
            let expectedSleeveCount = TestData.distinctEvents.count

            // Act
            for _ in 0..<expectedSleeveCount {
                control.nz.addAction(for: event) { }
            }

            // Assert
            #expect(TestData.sleeves(of: control).count == expectedSleeveCount)
        }

        @Test
        func testWhenDistinctClosuresRegisteredShouldInvokeEachOwnClosure() {
            // Arrange
            let control = TestData.control()
            let recorder = InvocationRecorder()
            let events = TestData.distinctEvents

            // Act
            for event in events {
                control.nz.addAction(for: event) { recorder.record() }
            }
            TestData.sleeves(of: control).forEach({ $0.invoke() })

            // Assert
            #expect(recorder.count == events.count)
        }
    }
}

#endif
