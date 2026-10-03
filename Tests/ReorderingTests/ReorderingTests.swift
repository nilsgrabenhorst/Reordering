import CoreGraphics
import Testing
@testable import Reordering

@MainActor
@Suite("Reorderable default itemID")
struct ReorderableTests {
    @Test func `itemID uses Identifiable.ID by default`() {
        let board = MockBoard()
        let item = MockItem(id: 42, title: "Hello")

        #expect(item[keyPath: board.itemID] == 42)
    }
}

// MARK: - Mocks

extension ReorderableTests {
    struct MockItem: Identifiable, Sendable {
        let id: Int
        var title: String
    }

    @MainActor
    final class MockBoard: Reorderable {
        typealias Item = MockItem
        typealias CollectionID = String

        private(set) var appliedDifferences: [Diff] = []
        var storage: [String: [MockItem]] = [:]

        func items(in collection: String) -> [MockItem] {
            storage[collection] ?? []
        }

        func apply(_ difference: Diff) {
            appliedDifferences.append(difference)
        }
    }
}
