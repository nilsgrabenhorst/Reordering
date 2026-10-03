//
//  HoverModelTests.swift
//  Reordering
//
//  Created by Nils Grabenhorst on 03.10.26.
//

import Testing
import CoreGraphics
@testable import Reordering

@MainActor
@Suite("HoverModel")
struct HoverModelTests {
    @Test func `isHovering reflects hovered collection`() {
        let model = HoverModel<String>()
        #expect(!model.isHovering(on: "a"))

        model.hoveredCollection = "a"
        #expect(model.isHovering(on: "a"))
        #expect(!model.isHovering(on: "b"))
    }

    @Test func `collection(at:) resolves by horizontal frame`() {
        let model = HoverModel<String>()
        model.setContainerFrame(.zero)
        model.setFrame(CGRect(x: 0, y: 0, width: 100, height: 100), for: "left")
        model.setFrame(CGRect(x: 100, y: 0, width: 100, height: 100), for: "right")

        #expect(model.collection(at: CGPoint(x: 50, y: 50)) == "left")
        #expect(model.collection(at: CGPoint(x: 150, y: 50)) == "right")
    }

    @Test func `collection(at:) returns nil outside`() {
        let model = HoverModel<String>()
        model.setContainerFrame(.zero)
        model.setFrame(CGRect(x: 0, y: 0, width: 100, height: 100), for: "only")

        #expect(model.collection(at: CGPoint(x: 500, y: 50)) == nil)
    }

    @Test func `collection(at:) respects container offsets`() {
        // `collection(at:)` adds `containerFrame.minX` to the point's x before
        // matching against stored column frames. Documenting/pinning down this
        // current behavior, surprising as it may look.
        let model = HoverModel<String>()
        model.setContainerFrame(CGRect(x: 20, y: 0, width: 100, height: 100))
        model.setFrame(CGRect(x: 0, y: 0, width: 100, height: 100), for: "a")

        // point.x (85) + containerFrame.minX (20) == 105, outside "a"'s 0...100
        #expect(model.collection(at: CGPoint(x: 85, y: 0)) == nil)
        // point.x (70) + containerFrame.minX (20) == 90, inside "a"'s 0...100
        #expect(model.collection(at: CGPoint(x: 70, y: 0)) == "a")
    }

    @Test func `isCollection(_:reorderableAt:) checks vertical span of cards`() {
        let model = HoverModel<String>()
        model.setItemsFrame(CGRect(x: 0, y: 0, width: 100, height: 200), for: "a")

        #expect(model.isCollection("a", reorderableAt: CGPoint(x: 10, y: 100)))
        #expect(!model.isCollection("a", reorderableAt: CGPoint(x: 10, y: 300)))
    }

    @Test func `isCollection(_:reorderableAt:) returns false if no itemsFrames available`() {
        let model = HoverModel<String>()
        #expect(!model.isCollection("missing", reorderableAt: .zero))
    }
}
