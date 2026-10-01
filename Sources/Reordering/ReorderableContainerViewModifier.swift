//
//  ReorderableContainerViewModifier.swift
//  Reordering
//
//  Created by Nils Grabenhorst on 28.09.26.
//

import SwiftUI

struct ReorderableContainerViewModifier<Collections: Reorderable>: ViewModifier {
    init(for collections: Collections,
         isEnabled: Bool = true) {
        self.collections = collections
        self.isEnabled = isEnabled
    }

    typealias Item = Collections.Item
    typealias CollectionID = Collections.CollectionID
    typealias Diff = Collections.Diff

    @State private var hoverModel = HoverModel<CollectionID>()
    private let collections: Collections
    private var isEnabled: Bool

    func body(content: Content) -> some View {
        content.reorderContainer(
            for: Item.self,
            itemID: collections.itemID,
            in: CollectionID.self,
            isEnabled: isEnabled,
            move: { difference in collections.apply(difference)}
        )
        .dropConfiguration { session in
            let isHovering: Bool
            switch session.phase {
            case .ended: isHovering = false
            case .exiting: isHovering = false
            case .entering: isHovering = true
            case .dataTransferCompleted: isHovering = false
            case .active: isHovering = true
            @unknown default: isHovering = false
            }
            let collection = hoverModel.collection(at: session.location)
            hoverModel.hoveredCollection = isHovering ? collection : nil

            if let destination = session.reorderDestination(for: Item.self,
                                                            itemID: collections.itemID,
                                                            in: CollectionID.self) {
                // This is apparently never called. Let's keep it for now, though.
                return DropConfiguration(operation: .move, destination: destination)
            } else if let collection, collections.items(in: collection).isEmpty {
                // If the column is empty, move the cards into it without reordering:
                let destination = Diff.Destination(position: .end, collectionID: collection)
                return DropConfiguration(operation: .move, destination: destination)
            } else if let collection, !hoverModel.isCollection(collection, reorderableAt: session.location) {
                // If the column is not empty, but the cards are dropped below the existing
                // cards, drop them at the end:
                let destination = Diff.Destination(position: .end, collectionID: collection)
                return DropConfiguration(operation: .move, destination: destination)
            } else {
                // If we are re-ordering within the column, let the system's own
                // per-card gap logic resolve the destination:
                return DropConfiguration(operation: .move)
            }
        }
        .onGeometryChange(for: CGRect.self, of: { $0.frame(in: .global) }) { frame in
            hoverModel.setContainerFrame(frame)
        }
        .environment(hoverModel)
    }
}

public extension View {
    func reorderContainer<Collections>(for collections: Collections,
                                       isEnabled: Bool = true) -> some View
    where Collections: Reorderable {
        modifier(ReorderableContainerViewModifier(for: collections, isEnabled: isEnabled))
    }
}
