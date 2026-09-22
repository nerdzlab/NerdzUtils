#if os(iOS)

import UIKit
import Testing
import NerdzCore

@testable import NerdzUIKit

private enum TestData {

    @MainActor
    static func controller() -> UIViewController {
        UIViewController()
    }

    @MainActor
    static func navigation(with controllers: [UIViewController]) -> UINavigationController {
        let navigation = UINavigationController()
        navigation.setViewControllers(controllers, animated: false)
        return navigation
    }

    @MainActor
    static func tabBar(with controllers: [UIViewController], selectedIndex: Int) -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.setViewControllers(controllers, animated: false)
        tabBar.selectedIndex = selectedIndex
        return tabBar
    }

    @MainActor
    static func containerWithChild(_ child: UIViewController) -> UIViewController {
        let container = UIViewController()
        container.addChild(child)
        container.view.addSubview(child.view)
        child.didMove(toParent: container)
        return container
    }
}

@Suite("UIViewController+Top")
@MainActor
struct UIViewControllerTopTests {

    @Test
    func testWhenControllerIsStandaloneShouldReturnItself() {
        // Arrange
        let controller = TestData.controller()

        // Act
        let top = controller.nz.topController

        // Assert
        #expect(top === controller)
    }

    @Test
    func testWhenControllerIsNavigationShouldReturnVisibleController() {
        // Arrange
        let expected = TestData.controller()
        let navigation = TestData.navigation(with: [TestData.controller(), expected])

        // Act
        let top = navigation.nz.topController

        // Assert
        #expect(top === expected)
    }

    @Test
    func testWhenControllerIsTabBarShouldReturnSelectedController() {
        // Arrange
        let expected = TestData.controller()
        let selectedIndex = 1
        let tabBar = TestData.tabBar(with: [TestData.controller(), expected], selectedIndex: selectedIndex)

        // Act
        let top = tabBar.nz.topController

        // Assert
        #expect(top === expected)
    }

    @Test
    func testWhenControllerHasChildShouldReturnChild() {
        // Arrange
        let expected = TestData.controller()
        let container = TestData.containerWithChild(expected)

        // Act
        let top = container.nz.topController

        // Assert
        #expect(top === expected)
    }

    @Test
    func testWhenHierarchyIsNestedShouldResolveDeepestController() {
        // Arrange
        let expected = TestData.controller()
        let navigation = TestData.navigation(with: [TestData.controller(), expected])
        let tabBar = TestData.tabBar(with: [TestData.controller(), navigation], selectedIndex: 1)

        // Act
        let top = tabBar.nz.topController

        // Assert
        #expect(top === expected)
    }

    @Test
    func testWhenNavigationIsEmptyShouldReturnNavigationItself() {
        // Arrange
        let navigation = TestData.navigation(with: [])

        // Act
        let top = navigation.nz.topController

        // Assert
        #expect(top === navigation)
    }
}

#endif
