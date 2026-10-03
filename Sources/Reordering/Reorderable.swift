//
//  Reorderable.swift
//  Reordering
//
//  Created by Nils Grabenhorst on 28.09.26.
//

import SwiftUI

/// Adopt `Reorderable` for your model to participate in reorderable drag&drop collections
///
/// This is best explained by example: a Kanban board with columns. The user can drag cards to move
/// them to a different column, or to re-order the cards within a column. We start with an `@Observable`
/// "BoardModel" model class, conforming to `Reorderable`.
///
/// There are a few viewModifiers to add to the views:
///
/// ## Step 1
/// Mark the view containing the columns as the `reorderContainer`:
///
///     struct BoardView: View {
///         @State private var board = BoardModel()
///
///         var body: some View {
///             HStack(alignment: .top, spacing: 0) {
///                 ForEach(BoardColumn.allCases) { (column: BoardColumn) in
///                     ColumnView(column: column, board: board)
///                 }
///             }
///             .reorderContainer(for: board) // 👈 participates in card re-ordering ✅
///         }
///     }
///
/// ## Step 2
/// Tell the system, where the draggable items are:
///
///     struct ColumnView: View {
///         let column: BoardColumn
///         @Bindable var board: BoardModel
///
///         var body: some View {
///             LazyVStack {
///                 ForEach(board.items(in: column)) { card in
///                     CardView(card)
///                 }
///                 .reorderable(column, in: board) // 👈 cards are draggable ✅
///             }
///         }
///     }
///
/// ### 🚨 Important Note:
///
/// The identifier used by `ForEach` must match the identifier `Reorderable` uses for its items
/// (`Reorderable.ItemID`) — otherwise SwiftUI can't match a dragged row back to a model item.
/// If that happens, the item to be dragged just would not move at all.
///
/// For `Identifiable` items whose `Item.ID` equals `Reorderable.ItemID`, this
/// just works. It's fine to omit `id:` from `ForEach` as shown in the code snippet above.
///
/// If your items are not `Identifiable`, or you need a different identifier for dragging, use
/// that same identifier for both `itemID` and the `ForEach`:
///
///       /*
///        * assuming the `Reorderable` board uses
///        * `card.dragIdentifer` to identify dragged
///        * items, we must use that same identifier
///        * here:
///        */
///     ForEach(board.items(in: column), id: \.dragIdentifier) { card in
///        ...
///     }
///     .reorderable(column, in: board)
///
/// `.reorderable(_:in:)` emits a compiler error if attached to a ForEach where the ID type does
/// not match the `ItemID` of `Reorderable`. In some cases it can also be attached to some
/// modifiers further down from the `ForEach`, but this only works if the modifiers carry the type of
/// the `ForEach` ID — This is the case if the modifiers return some `ModifiedContent`. Many of
/// Apple's view modifiers return type-erased content, which breaks the chain of ID type propagation.
/// In that case, just move the `.reorderable(_:in:)` modifier further up, ideally directly below
/// the `ForEach`.
///
/// Note: the compiler only checks that the *types* of `ForEach`'s `id:` and `Reorderable.ItemID`
/// match, not that they pick out the same value — two unrelated same-typed identifiers would
/// still type-check, so it's worth double-checking to make sure the identifiers actually agree.
///
/// ## Step 3
/// Back in `BoardView` (see Step 1), define the hoverable part of the view:
///
///     var body: some View {
///         // ...
///         ForEach(BoardColumn.allCases) { (column: BoardColumn) in
///             ColumnView(column: column, board: board)
///                 .reorderHoverable(for: column, in: board) // 👈 reacts when dragging over ✅
///         }
///         // ...
///     }
///
/// ## Step 4
/// Reac to to hovering events to highlight a column. There is an `\.isHovering` environment
/// value. We can use it to render a suble change of background color. In `ColumnView`:
///
///     struct ColumnView: View {
///         // ...
///
///         // ✅ Use this `EnvironmentValue` to react to the `isHovering` state:
///         @Environment(\.isHovering) private var isHovering
///
///         var body: some View {
///             // ...
///             .background {
///                 Color.gray.opacity(isHovering ? 0.05 : 0)
///             }
///         }
///     }
public protocol Reorderable {
    /// The type of the draggable/reorderable model items
    associatedtype Item
    
    /// The the type used as the identifier for an `Item`
    ///
    /// Defaults to `Item.ID` if `Item` conforms to `Identifiable`.
    ///
    /// - Note: Make sure to use the same identifier for the `ForEach`.
    ///         If identifiers don't match, reorderable dragging will
    ///         fail silently.
    associatedtype ItemID: Hashable & Sendable

    /// A type to identify each collection of `Item`s
    associatedtype CollectionID: Hashable & Sendable
    
    typealias Diff = ReorderDifference<ItemID, CollectionID>

    /// All items in the collection
    func items(in collection: CollectionID) -> [Item]
    
    /// Finish a drop by applying the given `defference`
    ///
    /// This method is called to finalise a drop. Update your model
    /// to reflect the new order of items by appying the given `Diff`.
    ///
    /// - Parameters:
    ///    - difference: An object containing the source and destination difference
    func apply(_ difference: Diff)
    
    /// A keypath to read the identifier of an item
    ///
    /// Default implementation available if `Item` conforms to `Identifiable`,
    /// where the `id` property is used.
    var itemID: KeyPath<Item, ItemID> { get }
}

public extension Reorderable where Item: Identifiable, Item.ID: Hashable & Sendable {
    typealias ItemID = Item.ID
    var itemID: KeyPath<Item, Item.ID> { \.id }
}
