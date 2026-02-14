import Testing
@testable import Tint

@Suite struct BufferTests {
    @Test func initialization() {
        let area = Rect(x: 0, y: 0, width: 5, height: 3)
        let buffer = Buffer(area: area)
        #expect(buffer.cells.count == 15)
        #expect(buffer[0, 0] == .empty)
    }

    @Test func writeText() {
        let area = Rect(x: 0, y: 0, width: 10, height: 1)
        var buffer = Buffer(area: area)
        buffer.write("Hello", x: 0, y: 0)
        #expect(buffer.textAt(row: 0) == "Hello     ")
    }

    @Test func writeTruncates() {
        let area = Rect(x: 0, y: 0, width: 5, height: 1)
        var buffer = Buffer(area: area)
        buffer.write("Hello, World!", x: 0, y: 0)
        #expect(buffer.textAt(row: 0) == "Hello")
    }

    @Test func writeWithOffset() {
        let area = Rect(x: 0, y: 0, width: 10, height: 1)
        var buffer = Buffer(area: area)
        buffer.write("Hi", x: 3, y: 0)
        buffer.assertCell(x: 3, y: 0, char: "H")
        buffer.assertCell(x: 4, y: 0, char: "i")
    }

    @Test func fill() {
        let area = Rect(x: 0, y: 0, width: 5, height: 3)
        var buffer = Buffer(area: area)
        let cell = Cell(character: "X", style: .default)
        buffer.fill(Rect(x: 1, y: 1, width: 2, height: 1), cell: cell)
        #expect(buffer[1, 1].character == "X")
        #expect(buffer[2, 1].character == "X")
        #expect(buffer[0, 1].character == " ")
    }

    @Test func setStyle() {
        let area = Rect(x: 0, y: 0, width: 5, height: 1)
        var buffer = Buffer(area: area)
        buffer.write("Hello", x: 0, y: 0)
        let style = Style(fg: .red, bold: true)
        buffer.setStyle(Rect(x: 0, y: 0, width: 3, height: 1), style: style)
        #expect(buffer[0, 0].style == style)
        #expect(buffer[2, 0].style == style)
        #expect(buffer[3, 0].style == .default)
    }

    @Test func merge() {
        let area1 = Rect(x: 0, y: 0, width: 10, height: 5)
        var buffer1 = Buffer(area: area1)
        buffer1.write("AAAA", x: 0, y: 0)

        let area2 = Rect(x: 2, y: 0, width: 3, height: 1)
        var buffer2 = Buffer(area: area2)
        buffer2.write("BBB", x: 2, y: 0)

        buffer1.merge(buffer2)
        #expect(buffer1[0, 0].character == "A")
        #expect(buffer1[1, 0].character == "A")
        #expect(buffer1[2, 0].character == "B")
        #expect(buffer1[3, 0].character == "B")
        #expect(buffer1[4, 0].character == "B")
    }

    @Test func reset() {
        let area = Rect(x: 0, y: 0, width: 5, height: 1)
        var buffer = Buffer(area: area)
        buffer.write("Hello", x: 0, y: 0)
        buffer.reset()
        #expect(buffer.textAt(row: 0) == "     ")
    }

    @Test func allText() {
        let area = Rect(x: 0, y: 0, width: 3, height: 2)
        var buffer = Buffer(area: area)
        buffer.write("AB", x: 0, y: 0)
        buffer.write("CD", x: 0, y: 1)
        let text = buffer.allText()
        #expect(text == ["AB ", "CD "])
    }

    @Test func outOfBoundsAccess() {
        let area = Rect(x: 0, y: 0, width: 5, height: 5)
        var buffer = Buffer(area: area)
        // Writing out of bounds should be silently ignored
        buffer.write("Test", x: -1, y: 0)
        buffer[10, 10] = Cell(character: "X")
        // Reading out of bounds returns empty
        #expect(buffer[10, 10] == .empty)
    }

    @Test func subscriptGetSet() {
        let area = Rect(x: 0, y: 0, width: 5, height: 5)
        var buffer = Buffer(area: area)
        let cell = Cell(character: "Z", style: Style(fg: .green))
        buffer[2, 3] = cell
        #expect(buffer[2, 3] == cell)
    }
}
