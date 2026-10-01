//
//  Identifying.swift
//  Reordering
//
//  Created by Nils Grabenhorst on 30.09.26.
//

import SwiftUI

public protocol Identifying {
    associatedtype ID
    associatedtype IdentifyingContent
}

public extension Identifying where Self: DynamicViewContent {
    /// Marks this `ForEach` as a reorderable/draggable collection identified by `collectionID`
    /// within `collections`.
    ///
    /// The `where` clause ties this `ForEach`'s row identity (`ID`) and element type
    /// (`Data.Element`) to `collections`' `ItemID` and `Item`. If they don't match — e.g. a
    /// custom `id:` keypath whose type disagrees with `Collections.ItemID` — this is now a
    /// compile error instead of a silent runtime mismatch. This only compares the *types* of
    /// the two identifiers, not that they resolve to the same underlying value.
    func reorderable<Collections: Reorderable>(
        _ collectionID: Collections.CollectionID,
        in collections: Collections
    ) -> some View
    where IdentifyingContent: View,
          Data.Element == Collections.Item,
          ID == Collections.ItemID {
        ReorderableView(collectionID: collectionID, collections: collections) {
            self
        }
    }
}
