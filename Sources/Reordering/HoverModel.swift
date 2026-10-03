//
//  HoverModel.swift
//  Reordering
//
//  Created by Nils Grabenhorst on 28.09.26.
//

import CoreGraphics
import Observation

@Observable
final class HoverModel<CollectionID: Hashable> {
    @ObservationIgnored
    private var columnFrames: [CollectionID: CGRect] = [:]

    @ObservationIgnored
    private var containerFrame = CGRect.zero

    // Frame of a stable, non-reorderable mirror of each column's cards, used
    // to know the real vertical extent of the card list independent of the
    // live reorder placeholder (which resizes the actual reorderable content
    // while dragging).
    @ObservationIgnored
    private var cardsFrames: [CollectionID: CGRect] = [:]

    var hoveredCollection: CollectionID?
    func isHovering(on column: CollectionID) -> Bool {
        column == hoveredCollection
    }

    func setContainerFrame(_ frame: CGRect) {
        containerFrame = frame
    }

    func setItemsFrame(_ frame: CGRect, for collection: CollectionID) {
        cardsFrames[collection] = frame
    }

    func setFrame(_ frame: CGRect, for collection: CollectionID) {
        columnFrames[collection] = frame
    }

    func collection(at globalPoint: CGPoint) -> CollectionID? {
        let x = globalPoint.x + containerFrame.minX
        return columnFrames.first { _, frame in frame.horizontalSpan.contains(x: x) }?.key
    }

    func isCollection(_ collection: CollectionID, reorderableAt point: CGPoint) -> Bool {
        guard let frame = cardsFrames[collection] else { return false }
        return frame.verticalSpan.contains(point)
    }
}

nonisolated struct HorizontalSpan {
    let span: ClosedRange<CGFloat>

    func contains(_ point: CGPoint) -> Bool {
        contains(x: point.x)
    }

    func contains(x: CGFloat) -> Bool {
        span.contains(x)
    }
}

nonisolated struct VerticalSpan {
    let span: ClosedRange<CGFloat>

    func contains(_ point: CGPoint) -> Bool {
        contains(y: point.y)
    }

    func contains(y: CGFloat) -> Bool {
        span.contains(y)
    }
}

extension CGRect {
    nonisolated var horizontalSpan: HorizontalSpan {
        HorizontalSpan(span: minX...maxX)
    }
    nonisolated var verticalSpan: VerticalSpan {
        VerticalSpan(span: minY...maxY)
    }
}
