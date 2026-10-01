//
//  ForEach+reorderable.swift
//  Reordering
//
//  Created by Nils Grabenhorst on 28.09.26.
//

import SwiftUI

extension ForEach: Identifying {
    public typealias IdentifyingContent = Content
}

extension ModifiedContent: Identifying where Content: Identifying {
    public typealias IdentifyingContent = Content
    public typealias ID = Content.ID
}

struct ReorderableView<Collections: Reorderable, Content: DynamicViewContent>: View {
    init(collectionID: Collections.CollectionID,
         collections: Collections,
         content: @escaping () -> Content) {
        self.content = content()
        self.collectionID = collectionID
        self.collections = collections
    }

    let content: Content
    let collectionID: Collections.CollectionID
    let collections: Collections

    @Environment(HoverModel<Collections.CollectionID>.self) private var hoverModel

    var body: some View {
        content
            .reorderable(collectionID: collectionID)
            .onGeometryChange(for: CGRect.self) {
                $0.frame(in: .local)
            } action: { frame in
                hoverModel.setItemsFrame(frame, for: collectionID)
            }
    }
}
