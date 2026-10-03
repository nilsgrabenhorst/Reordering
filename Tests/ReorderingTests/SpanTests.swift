//
//  SpanTests.swift
//  Reordering
//
//  Created by Nils Grabenhorst on 03.10.26.
//

import Testing
import CoreGraphics
@testable import Reordering

@MainActor
@Suite("HorizontalSpan / VerticalSpan")
struct SpanTests {
    @Test func `HorizontalSpan contains x value`() {
        let span = HorizontalSpan(span: 10...20)
        #expect(span.contains(x: 10))
        #expect(span.contains(x: 15))
        #expect(span.contains(x: 20))
    }
    
    @Test func `HorizontalSpan does not contain x value`() {
        let span = HorizontalSpan(span: 10...20)
        #expect(!span.contains(x: 9.999))
        #expect(!span.contains(x: 20.001))
    }

    @Test func `HorizontalSpan contains CGPoint.x`() {
        let span = HorizontalSpan(span: 0...10)
        #expect(span.contains(CGPoint(x: 5, y: 1_000)))
    }
    
    @Test func `HorizontalSpan does not contain CGPoint.x`() {
        let span = HorizontalSpan(span: 0...10)
        #expect(!span.contains(CGPoint(x: 11, y: 0)))
    }

    @Test func `VerticalSpan contains y value`() {
        let span = VerticalSpan(span: 10...20)
        #expect(span.contains(y: 10))
        #expect(span.contains(y: 20))
    }
    
    @Test func `VerticalSpan does not contain y value`() {
        let span = VerticalSpan(span: 10...20)
        #expect(!span.contains(y: 9.999))
        #expect(!span.contains(y: 20.001))
    }

    @Test func `VerticalSpan contains CGPoint.y`() {
        let span = VerticalSpan(span: 0...10)
        #expect(span.contains(CGPoint(x: 1_000, y: 5)))
    }
    
    @Test func `VerticalSpan does not contain CGPoint.y`() {
        let span = VerticalSpan(span: 0...10)
        #expect(!span.contains(CGPoint(x: 0, y: 11)))
    }

    @Test func `CGRect.horizontalSpan derives from min/max X`() {
        let rect = CGRect(x: 5, y: 10, width: 100, height: 50)

        #expect(rect.horizontalSpan.contains(x: 5))
        #expect(rect.horizontalSpan.contains(x: 105))
        #expect(!rect.horizontalSpan.contains(x: 4.999))
        #expect(!rect.horizontalSpan.contains(x: 105.001))
    }
    
    @Test func `CGRect.verticalSpan derives from min/max Y`() {
        let rect = CGRect(x: 5, y: 10, width: 100, height: 50)

        #expect(rect.verticalSpan.contains(y: 10))
        #expect(rect.verticalSpan.contains(y: 60))
        #expect(!rect.verticalSpan.contains(y: 9.999))
        #expect(!rect.verticalSpan.contains(y: 60.001))
    }
}
