import Testing
@testable import Tint

@Suite struct TextTests {
    @Test func singleLineText() {
        let area = Rect(x: 0, y: 0, width: 10, height: 1)
        var buffer = Buffer(area: area)
        let text = Text("Hello")
        text.render(area: area, buffer: &buffer)
        buffer.assertRow(0, equals: "Hello")
    }

    @Test func multiLineText() {
        let area = Rect(x: 0, y: 0, width: 10, height: 3)
        var buffer = Buffer(area: area)
        let text = Text("Line 1\nLine 2\nLine 3")
        text.render(area: area, buffer: &buffer)
        buffer.assertRow(0, equals: "Line 1")
        buffer.assertRow(1, equals: "Line 2")
        buffer.assertRow(2, equals: "Line 3")
    }

    @Test func centerAlignment() {
        let area = Rect(x: 0, y: 0, width: 10, height: 1)
        var buffer = Buffer(area: area)
        let text = Text("Hi", alignment: .center)
        text.render(area: area, buffer: &buffer)
        // "Hi" is 2 chars, centered in 10 → offset 4
        buffer.assertCell(x: 4, y: 0, char: "H")
        buffer.assertCell(x: 5, y: 0, char: "i")
    }

    @Test func rightAlignment() {
        let area = Rect(x: 0, y: 0, width: 10, height: 1)
        var buffer = Buffer(area: area)
        let text = Text("Hi", alignment: .right)
        text.render(area: area, buffer: &buffer)
        // "Hi" is 2 chars, right-aligned in 10 → offset 8
        buffer.assertCell(x: 8, y: 0, char: "H")
        buffer.assertCell(x: 9, y: 0, char: "i")
    }

    @Test func truncation() {
        let area = Rect(x: 0, y: 0, width: 3, height: 1)
        var buffer = Buffer(area: area)
        let text = Text("Hello")
        text.render(area: area, buffer: &buffer)
        #expect(buffer.textAt(row: 0) == "Hel")
    }

    @Test func styledSpans() {
        let area = Rect(x: 0, y: 0, width: 10, height: 1)
        var buffer = Buffer(area: area)
        let line = TextLine([
            StyledSpan("Red", style: Style(fg: .red)),
            StyledSpan("Blue", style: Style(fg: .blue)),
        ])
        let text = Text(lines: [line])
        text.render(area: area, buffer: &buffer)
        #expect(buffer[0, 0].style.fg == .red)
        #expect(buffer[3, 0].style.fg == .blue)
    }

    @Test func emptyArea() {
        let area = Rect(x: 0, y: 0, width: 0, height: 0)
        var buffer = Buffer(area: area)
        let text = Text("Hello")
        // Should not crash
        text.render(area: area, buffer: &buffer)
    }

    @Test func textClippedVertically() {
        let area = Rect(x: 0, y: 0, width: 10, height: 1)
        var buffer = Buffer(area: area)
        let text = Text("Line 1\nLine 2\nLine 3")
        text.render(area: area, buffer: &buffer)
        // Only first line should render
        buffer.assertRow(0, equals: "Line 1")
    }
}
