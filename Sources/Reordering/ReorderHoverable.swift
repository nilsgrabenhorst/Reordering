//
//  ReorderHoverable.swift
//  Reordering
//
//  Created by Nils Grabenhorst on 28.09.26.
//

import SwiftUI

extension EnvironmentValues {
    @Entry public var isHovering: Bool = false
}

struct ReorderHoverable<Collections: Reorderable>: ViewModifier {
    @Environment(HoverModel<Collections.CollectionID>.self) private var hoverModel
    let collection: Collections.CollectionID

    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGRect.self, of: { $0.frame(in: .global) }) { frame in
                hoverModel.setFrame(frame, for: collection)
            }
            .environment(\.isHovering, hoverModel.isHovering(on: collection))
    }
}

public extension View {
    func reorderHoverable<Collections: Reorderable>(for collection: Collections.CollectionID, in collections: Collections) -> some View {
        modifier(ReorderHoverable<Collections>(collection: collection))
    }
}
