//
//  BoardModel.swift
//  ReorderingDemo
//

import SwiftUI
import Observation
import Reordering

@Observable
final class BoardModel {
    private var cards: [BoardColumn: [TaskCard]] = [
        .ideas: ["Hello", "Yo!"],
        .building: ["Crazy idea"],
        .shipped: [],
    ]
}

extension BoardModel: Reorderable {
    typealias Item = TaskCard
    typealias CollectionID = BoardColumn

    func items(in collection: BoardColumn) -> [TaskCard] {
        cards[collection] ?? []
    }

    func apply(_ difference: Diff) {
        var cardsToMove: [TaskCard] = []
        for movedCardID in difference.sources {
            for column in BoardColumn.allCases {
                if let index = cards[column]?.firstIndex(where: { $0.id == movedCardID }) {
                    if let card = cards[column]?.remove(at: index) {
                        cardsToMove.append(card)
                    }
                }
            }
        }
        let destination = difference.destination.collectionID
        switch difference.destination.position {
        case .before(let itemID):
            if let index = cards[destination]?.firstIndex(where: { $0.id == itemID }) {
                cards[destination]?.insert(contentsOf: cardsToMove, at: index)
            } else {
                cards[destination]?.append(contentsOf: cardsToMove)
            }
        case .end:
            cards[destination]?.append(contentsOf: cardsToMove)
        }
    }
}
