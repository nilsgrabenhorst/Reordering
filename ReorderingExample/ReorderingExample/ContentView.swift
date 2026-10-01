import CoreTransferable
import SwiftUI
import UniformTypeIdentifiers
import Observation
import Reordering

struct ContentView: View {
    var body: some View {
        BoardView()
    }
}

struct BoardView: View {
    @State private var board = BoardModel()

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(BoardColumn.allCases) { (column: BoardColumn) in
                ColumnView(column: column, board: board)
                    .reorderHoverable(for: column, in: board)
            }
        }
        .reorderContainer(for: board)
        .dropPreviewsFormation(.pile)
    }
}

struct ColumnView: View {
    init(column: BoardColumn, board: BoardModel) {
        self.column = column
        self.board = board
    }

    let column: BoardColumn
    @Bindable var board: BoardModel
    @Environment(\.isHovering) private var isHovering

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
                        }
                        .reorderable(column, in: board)
                    }
                }
            }
        }
        .background {
            Color.gray.opacity(isHovering ? 0.05 : 0)
        }
    }
}

struct CardView: View {
    init(_ card: TaskCard) {
        self.card = card
    }

    let card: TaskCard

    var body: some View {
        Text(card.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.orange, in: RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
