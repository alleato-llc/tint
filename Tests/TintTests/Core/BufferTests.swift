import XCTest
@testable import Tint

final class BufferTests: XCTestCase {
    func testInitialization() {
        let area = Rect(x: 0, y: 0, width: 5, height: 3)
        let buffer = Buffer(area: area)
        XCTAssertEqual(buffer.cells.count, 15)
        XCTAssertEqual(buffer[0, 0], .empty)
    }

    func testWriteText() {
        let area = Rect(x: 0, y: 0, width: 10, height: 1)
        var buffer = Buffer(area: area)
        buffer.write("Hello", x: 0, y: 0)
        XCTAssertEqual(buffer.textAt(row: 0), "Hello     ")
    }

    func testWriteTruncates() {
        let area = Rect(x: 0, y: 0, width: 5, height: 1)
        var buffer = Buffer(area: area)
        buffer.write("Hello, World!", x: 0, y: 0)
        XCTAssertEqual(buffer.textAt(row: 0), "Hello")
    }

    func testWriteWithOffset() {
        let area = Rect(x: 0, y: 0, width: 10, height: 1)
        var buffer = Buffer(area: area)
        buffer.write("Hi", x: 3, y: 0)
        buffer.assertCell(x: 3, y: 0, char: "H")
        buffer.assertCell(x: 4, y: 0, char: "i")
    }

    func testFill() {
        let area = Rect(x: 0, y: 0, width: 5, height: 3)
        var buffer = Buffer(area: area)
        let cell = Cell(character: "X", style: .default)
        buffer.fill(Rect(x: 1, y: 1, width: 2, height: 1), cell: cell)
        XCTAssertEqual(buffer[1, 1].character, "X")
        XCTAssertEqual(buffer[2, 1].character, "X")
        XCTAssertEqual(buffer[0, 1].character, " ")
    }

    func testSetStyle() {
        let area = Rect(x: 0, y: 0, width: 5, height: 1)
        var buffer = Buffer(area: area)
        buffer.write("Hello", x: 0, y: 0)
        let style = Style(fg: .red, bold: true)
        buffer.setStyle(Rect(x: 0, y: 0, width: 3, height: 1), style: style)
        XCTAssertEqual(buffer[0, 0].style, style)
        XCTAssertEqual(buffer[2, 0].style, style)
        XCTAssertEqual(buffer[3, 0].style, .default)
    }

    func testMerge() {
        let area1 = Rect(x: 0, y: 0, width: 10, height: 5)
        var buffer1 = Buffer(area: area1)
        buffer1.write("AAAA", x: 0, y: 0)

        let area2 = Rect(x: 2, y: 0, width: 3, height: 1)
        var buffer2 = Buffer(area: area2)
        buffer2.write("BBB", x: 2, y: 0)

        buffer1.merge(buffer2)
        XCTAssertEqual(buffer1[0, 0].character, "A")
        XCTAssertEqual(buffer1[1, 0].character, "A")
        XCTAssertEqual(buffer1[2, 0].character, "B")
        XCTAssertEqual(buffer1[3, 0].character, "B")
        XCTAssertEqual(buffer1[4, 0].character, "B")
    }

    func testReset() {
        let area = Rect(x: 0, y: 0, width: 5, height: 1)
        var buffer = Buffer(area: area)
        buffer.write("Hello", x: 0, y: 0)
        buffer.reset()
        XCTAssertEqual(buffer.textAt(row: 0), "     ")
    }

    func testAllText() {
        let area = Rect(x: 0, y: 0, width: 3, height: 2)
        var buffer = Buffer(area: area)
        buffer.write("AB", x: 0, y: 0)
        buffer.write("CD", x: 0, y: 1)
        let text = buffer.allText()
        XCTAssertEqual(text, ["AB ", "CD "])
    }

    func testOutOfBoundsAccess() {
        let area = Rect(x: 0, y: 0, width: 5, height: 5)
        var buffer = Buffer(area: area)
        // Writing out of bounds should be silently ignored
        buffer.write("Test", x: -1, y: 0)
        buffer[10, 10] = Cell(character: "X")
        // Reading out of bounds returns empty
        XCTAssertEqual(buffer[10, 10], .empty)
    }

    func testSubscriptGetSet() {
        let area = Rect(x: 0, y: 0, width: 5, height: 5)
        var buffer = Buffer(area: area)
        let cell = Cell(character: "Z", style: Style(fg: .green))
        buffer[2, 3] = cell
        XCTAssertEqual(buffer[2, 3], cell)
    }
}
