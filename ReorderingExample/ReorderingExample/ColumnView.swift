//
//  ColumnView.swift
//  ReorderingExample
//
//  Created by Nils Grabenhorst on 01.10.26.
//

import SwiftUI
import Reordering

struct ColumnView: View {
    init(column: BoardColumn, board: BoardModel) {
        self.column = column
        self.board = board
    }

    private let column: BoardColumn
    @Bindable private var board: BoardModel
    @Environment(\.isHovering) private var isHovering
    @Environment(SelectionModel<TaskCard>.self) private var selections

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(column.rawValue.capitalized)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.headline)
                .padding()

            ScrollView(.vertical) {
                ZStack(alignment: .top) {
                    LazyVStack {
                        ForEach(board.items(in: column)) { card in
                            CardView(card)
                                .padding(.horizontal, 4)
                        }
                        .reorderable(column, in: board)
                    }
                }
            }
        }
        .background {
            Color.gray.opacity(isHovering ? 0.08 : 0)
        }
        .onTapGesture {
            selections.deselectAll()
        }
    }
}
