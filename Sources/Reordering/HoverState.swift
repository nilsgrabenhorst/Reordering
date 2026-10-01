//
//  HoverState.swift
//  Reordering
//
//  Created by Nils Grabenhorst on 28.09.26.
//

import SwiftUI

@propertyWrapper
struct HoverState<CollectionID: Hashable>: DynamicProperty {
    @Environment(HoverModel<CollectionID>.self) private var hoverModel
    let collection: CollectionID

    var wrappedValue: Bool {
        hoverModel.isHovering(on: collection)
    }
}
