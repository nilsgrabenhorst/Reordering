//
//  TaskCard.swift
//  ReorderingDemo
//

import Foundation
import CoreTransferable
import UniformTypeIdentifiers

struct TaskCard: Identifiable, Transferable, Hashable, Codable, ExpressibleByStringLiteral {

    init(_ title: String) {
        self.title = title
    }

    init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }

    var title: String
    var id: String { title }

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .data)
    }
}
