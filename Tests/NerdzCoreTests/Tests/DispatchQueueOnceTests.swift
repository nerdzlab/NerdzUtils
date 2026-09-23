//
//  DispatchQueueOnceTests.swift
//  NerdzCoreTests
//

import Foundation
import Testing
@testable import NerdzCore

private final class TokenOwner: @unchecked Sendable { }

private enum TestData {

    static let concurrentIterations = 64

    static let singleExecutionCount = 1

    static func createToken() -> String {
        UUID().uuidString
    }

    static func createOwner() -> TokenOwner {
        TokenOwner()
    }
}

@Suite("DispatchQueue Once")
struct DispatchQueueOnceTests {

    @Suite("Once Per Token")
    struct OncePerToken {

        @Test
        func testWhenTokenIsUsedFirstTimeShouldExecuteAction() {
            // Arrange
            let token = TestData.createToken()
            let captor = CallbackCaptor<Void>()

            // Act
            DispatchQueue.nz.once(for: token) {
                captor.record()
            }

            // Assert
            #expect(captor.count == 1)
        }

        @Test
        func testWhenSameTokenIsUsedTwiceShouldExecuteActionOnce() {
            // Arrange
            let token = TestData.createToken()
            let captor = CallbackCaptor<Void>()

            // Act
            DispatchQueue.nz.once(for: token) {
                captor.record()
            }

            DispatchQueue.nz.once(for: token) {
                captor.record()
            }

            // Assert
            #expect(captor.count == 1)
        }

        @Test
        func testWhenDifferentTokensAreUsedShouldExecuteEveryAction() {
            // Arrange
            let firstToken = TestData.createToken()
            let secondToken = TestData.createToken()
            let captor = CallbackCaptor<String>()

            // Act
            DispatchQueue.nz.once(for: firstToken) {
                captor.record(firstToken)
            }

            DispatchQueue.nz.once(for: secondToken) {
                captor.record(secondToken)
            }

            // Assert
            #expect(captor.values == [firstToken, secondToken])
        }
    }

    @Suite("Once Per Object")
    struct OncePerObject {

        @Test
        func testWhenObjectAndTokenAreUsedFirstTimeShouldExecuteAction() {
            // Arrange
            let owner = TestData.createOwner()
            let token = TestData.createToken()
            let captor = CallbackCaptor<Void>()

            // Act
            DispatchQueue.nz.once(per: owner, token: token) {
                captor.record()
            }

            // Assert
            #expect(captor.count == 1)
        }

        @Test
        func testWhenSameObjectAndTokenAreUsedTwiceShouldExecuteActionOnce() {
            // Arrange
            let owner = TestData.createOwner()
            let token = TestData.createToken()
            let captor = CallbackCaptor<Void>()

            // Act
            DispatchQueue.nz.once(per: owner, token: token) {
                captor.record()
            }

            DispatchQueue.nz.once(per: owner, token: token) {
                captor.record()
            }

            // Assert
            #expect(captor.count == 1)
        }

        @Test
        func testWhenDifferentObjectsUseSameTokenShouldExecuteActionForEachObject() {
            // Arrange
            let firstOwner = TestData.createOwner()
            let secondOwner = TestData.createOwner()
            let token = TestData.createToken()
            let captor = CallbackCaptor<Void>()

            // Act
            DispatchQueue.nz.once(per: firstOwner, token: token) {
                captor.record()
            }

            DispatchQueue.nz.once(per: secondOwner, token: token) {
                captor.record()
            }

            // Assert
            #expect(captor.count == 2)
        }

        @Test
        func testWhenSameObjectUsesDifferentTokensShouldExecuteEveryAction() {
            // Arrange
            let owner = TestData.createOwner()
            let firstToken = TestData.createToken()
            let secondToken = TestData.createToken()
            let captor = CallbackCaptor<Void>()

            // Act
            DispatchQueue.nz.once(per: owner, token: firstToken) {
                captor.record()
            }

            DispatchQueue.nz.once(per: owner, token: secondToken) {
                captor.record()
            }

            // Assert
            #expect(captor.count == 2)
        }
    }

    @Suite("Concurrent Access")
    struct ConcurrentAccess {

        @Test
        func testWhenSameTokenIsUsedFromManyThreadsShouldExecuteActionOnce() {
            // Arrange
            let token = TestData.createToken()
            let captor = CallbackCaptor<Void>()

            // Act
            DispatchQueue.concurrentPerform(iterations: TestData.concurrentIterations) { _ in
                DispatchQueue.nz.once(for: token) {
                    captor.record()
                }
            }

            // Assert
            #expect(captor.count == TestData.singleExecutionCount)
        }

        @Test
        func testWhenSameObjectAndTokenAreUsedFromManyThreadsShouldExecuteActionOnce() {
            // Arrange
            let owner = TestData.createOwner()
            let token = TestData.createToken()
            let captor = CallbackCaptor<Void>()

            // Act
            DispatchQueue.concurrentPerform(iterations: TestData.concurrentIterations) { _ in
                DispatchQueue.nz.once(per: owner, token: token) {
                    captor.record()
                }
            }

            // Assert
            #expect(captor.count == TestData.singleExecutionCount)
        }

        @Test
        func testWhenDifferentTokensAreUsedFromManyThreadsShouldExecuteEveryAction() {
            // Arrange
            let tokens = (0..<TestData.concurrentIterations).map { _ in TestData.createToken() }
            let captor = CallbackCaptor<Void>()

            // Act
            DispatchQueue.concurrentPerform(iterations: tokens.count) { index in
                DispatchQueue.nz.once(for: tokens[index]) {
                    captor.record()
                }
            }

            // Assert
            #expect(captor.count == tokens.count)
        }
    }
}
