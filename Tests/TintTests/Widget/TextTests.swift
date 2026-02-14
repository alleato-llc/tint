import XCTest
@testable import Tint

final class TextTests: XCTestCase {
    func testSingleLineText() {
        let area = Rect(x: 0, y: 0, width: 10, height: 1)
        var buffer = Buffer(area: area)
        let text = Text("Hello")
        text.render(area: area, buffer: &buffer)
        buffer.assertRow(0, equals: "Hello")
    }

    func testMultiLineText() {
        let area = Rect(x: 0, y: 0, width: 10, height: 3)
        var buffer = Buffer(area: area)
        let text = Text("Line 1\nLine 2\nLine 3")
        text.render(area: area, buffer: &buffer)
        buffer.assertRow(0, equals: "Line 1")
        buffer.assertRow(1, equals: "Line 2")
        buffer.assertRow(2, equals: "Line 3")
    }

    func testCenterAlignment() {
        let area = Rect(x: 0, y: 0, width: 10, height: 1)
        var buffer = Buffer(area: area)
        let text = Text("Hi", alignment: .center)
        text.render(area: area, buffer: &buffer)
        // "Hi" is 2 chars, centered in 10 → offset 4
        buffer.assertCell(x: 4, y: 0, char: "H")
        buffer.assertCell(x: 5, y: 0, char: "i")
    }

    func testRightAlignment() {
        let area = Rect(x: 0, y: 0, width: 10, height: 1)
        var buffer = Buffer(area: area)
        let text = Text("Hi", alignment: .right)
        text.render(area: area, buffer: &buffer)
        // "Hi" is 2 chars, right-aligned in 10 → offset 8
        buffer.assertCell(x: 8, y: 0, char: "H")
        buffer.assertCell(x: 9, y: 0, char: "i")
    }

    func testTruncation() {
        let area = Rect(x: 0, y: 0, width: 3, height: 1)
        var buffer = Buffer(area: area)
        let text = Text("Hello")
        text.render(area: area, buffer: &buffer)
        XCTAssertEqual(buffer.textAt(row: 0), "Hel")
    }

    func testStyledSpans() {
        let area = Rect(x: 0, y: 0, width: 10, height: 1)
        var buffer = Buffer(area: area)
        let line = TextLine([
            StyledSpan("Red", style: Style(fg: .red)),
            StyledSpan("Blue", style: Style(fg: .blue)),
        ])
        let text = Text(lines: [line])
        text.render(area: area, buffer: &buffer)
        XCTAssertEqual(buffer[0, 0].style.fg, .red)
        XCTAssertEqual(buffer[3, 0].style.fg, .blue)
    }

    func testEmptyArea() {
        let area = Rect(x: 0, y: 0, width: 0, height: 0)
        var buffer = Buffer(area: area)
        let text = Text("Hello")
        // Should not crash
        text.render(area: area, buffer: &buffer)
    }

    func testTextClippedVertically() {
        let area = Rect(x: 0, y: 0, width: 10, height: 1)
        var buffer = Buffer(area: area)
        let text = Text("Line 1\nLine 2\nLine 3")
        text.render(area: area, buffer: &buffer)
        // Only first line should render
        buffer.assertRow(0, equals: "Line 1")
    }
}
