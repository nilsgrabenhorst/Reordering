//
//  BoardView.swift
//  ReorderingExample
//
//  Created by Nils Grabenhorst on 01.10.26.
//

import SwiftUI
import Reordering

struct BoardView: View {
    @State private var board = BoardModel()
    @State private var selections = SelectionModel<TaskCard>()

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(BoardColumn.allCases) { (column: BoardColumn) in
                ColumnView(column: column, board: board)
                    .reorderHoverable(for: column, in: board)
            }
        }
        .reorderContainer(for: board)
        .dragContainer(for: TaskCard.self, itemID: \.id) { draggedItemIDs in
            board.cards(for: draggedItemIDs)
        }
        .dragContainerSelection(Array(selections.selectedIDs))
        .environment(selections)
    }
}

#Preview {
    BoardView()
}
