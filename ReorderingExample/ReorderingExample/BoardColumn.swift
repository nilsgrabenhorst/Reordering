//
//  BoardColumn.swift
//  ReorderingDemo
//

import Foundation

enum BoardColumn: String, CaseIterable, Identifiable, Hashable, Sendable {
    case ideas
    case building
    case shipped

    var id: String { rawValue }
}
