//
//  CardView.swift
//  ReorderingExample
//
//  Created by Nils Grabenhorst on 01.10.26.
//

import SwiftUI

struct CardView: View {
    init(_ card: TaskCard) {
        self.card = card
    }

    private let card: TaskCard
    @Environment(SelectionModel<TaskCard>.self) private var selections
    private var isSelected: Bool {
        selections.isSelected(card)
    }

    var body: some View {
        Text(card.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.orange, in: RoundedRectangle(cornerRadius: 8))
            .highPriorityGesture(
                TapGesture().modifiers(.shift).onEnded {
                    selections.toggleSelection(for: card)
                }
            )
            .onTapGesture {
                selections.deselectAll()
                selections.toggleSelection(for: card)
            }
            .padding(3)
            .background {
                RoundedRectangle(cornerRadius: 10.5)
                    .stroke(lineWidth: 2)
                    .foregroundColor(
                        .blue.opacity(isSelected ? 1 : 0)
                    )
            }
            .padding(2)
    }
}

#Preview {
    @Previewable @State var selectionModel = SelectionModel<TaskCard>()
    CardView(TaskCard("Task"))
        .padding()
        .frame(width: 200)
        .environment(selectionModel)
}
