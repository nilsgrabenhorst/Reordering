//
//  SelectionModel.swift
//  ReorderingExample
//
//  Created by Nils Grabenhorst on 01.10.26.
//

import Foundation
import Observation

@Observable
final class SelectionModel<T: Identifiable> {
    private(set) var selectedIDs: Set<T.ID> = []

    subscript(_ id: T.ID) -> Bool {
        get {
            selectedIDs.contains(id)
        }
        set(nowSelected) {
            if nowSelected {
                selectedIDs.insert(id)
            } else {
                selectedIDs.remove(id)
            }
        }
    }
    
    func toggleSelection(for item: T) {
        self[item.id].toggle()
    }
    
    func deselectAll() {
        selectedIDs.removeAll()
    }
    
    func isSelected(_ item: T) -> Bool {
        self[item.id]
    }
}
