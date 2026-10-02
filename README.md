# Reordering

A Swift package that wraps SwiftUI's native drag-to-reorder APIs,
making drag & drop with reordering available for different styles
of containers (not just `ForEach` wrapped in a `List`).

## Requirements

- Swift 6.4
- iOS 27, macOS 27, or visionOS 27

## Package: `Reordering`

The package doesn't reimplement drag-and-drop; it wraps SwiftUI's own
`reorderContainer`/`.reorderable()`/`dragContainer` APIs. A model only needs
to conform to the `Reorderable` protocol to assist wiring up `ReorderDifference`,
`DropConfiguration`, and hover-frame tracking.

### Conform to `Reorderable`

Adopt `Reorderable` on a model that owns one or more ordered
collections of items:

```swift
protocol Reorderable {
    /// Return all items of the given collection
    func items(in collection: CollectionID) -> [Item]
    
    /// Finalise the drop
    /// receives the moved item IDs (`difference.sources`) and where they
    /// should land (`difference.destination`): mutate your model's storage
    func apply(_ difference: Diff)
    
    /// A keypath to read the identifier of an item
    /// Default implementation available if `Item` conforms to `Identifiable`
    var itemID: KeyPath<Item, ItemID> { get }
}
```

### Implement your `View`

  1. Define the reorderable container
  
  Mark the view containing all collections as the reorder container:

```swift
struct BoardView: View {
    @State private var board = BoardModel()

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(BoardColumn.allCases) { column in
                // This is one of the collections in the container:
                ColumnView(column: column, board: board)
            }
        }
        .reorderContainer(for: board)
    }
}
```

  2. Define the source of draggable items
  
  Use `.reorderable` to mark the `ForEach` with the draggable items:

```swift
// Somewhere inside `ColumnView`:
LazyVStack {
    ForEach(board.items(in: column)) { card in
        // This is one draggable item:
        CardView(card)
    }
    .reorderable(column, in: board)
}
```

The type of the identifier used by `ForEach` must match `Reorderable.ItemID`. For
`Identifiable` items whose `ID` equals `ItemID`, the default `id:` works and can
be omitted. `.reorderable(_:in:)` type-check the identifier at compile time. This
only works if the id type is available. Modifiers further down the chain may break
identifier type propagation if their `Content` is type-erased; that is the case
for most of Apple's modifiers. So it's best to put `.reorderable(_:in:)` directly
below the `ForEach`.

  3. Define hoverable views
  
  Mark each collection's container as hoverable. This enables a visual hover
  effect (see step 4), but more importantly lets users drop items into empty
  areas of a collection, or even drop items into completely empty collections:

```swift
ColumnView(column: column, board: board)
    .reorderHoverable(for: column, in: board)
```

  4. Visualize when dragging over a collection
  
  React to the `\.isHovering` environment value to
  highlight a collection while something is dragged over it:

```swift
// needs `.reorderHoverable(for:, in:)` to be set (see step 3)
@Environment(\.isHovering) private var isHovering

var body: some View {
    // ...
    
    // Let's adjust the background color when hovering:
    .background { Color.gray.opacity(isHovering ? 0.1 : 0) }
}
```

### Dragging multiple items

SwiftUI's `dragContainer`/`dragContainerSelection` APIs are supported to
allow for dragging and reordering multiple items. Just add them after
`reorderContainer(for:)` in this order:

```swift
.reorderContainer(for: board)
.dragContainer(for: TaskCard.self, itemID: \.id) { draggedItemIDs in
    board.cards(for: draggedItemIDs)
}
.dragContainerSelection(Array(selections.selectedIDs))
```

## Example: `ReorderingExample`

To see the package in action, there is a simple demo app included. It implements
a rudimentary Kanban board.

## License

MIT — see [LICENSE](LICENSE).
