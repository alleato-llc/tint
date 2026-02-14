import XCTest
import Tint

extension Buffer {
    /// Assert the text content of a specific row matches expected string (trimming trailing spaces).
    func assertRow(_ row: Int, equals expected: String, file: StaticString = #filePath, line: UInt = #line) {
        let actual = textAt(row: row)
        let trimmed = String(actual.reversed().drop(while: { $0 == " " }).reversed())
        XCTAssertEqual(trimmed, expected, "Row \(row) mismatch", file: file, line: line)
    }

    /// Assert the character at a specific position.
    func assertCell(x: Int, y: Int, char expected: Character, file: StaticString = #filePath, line: UInt = #line) {
        let cell = self[x, y]
        XCTAssertEqual(cell.character, expected, "Cell (\(x), \(y)) character mismatch", file: file, line: line)
    }

    /// Assert the style at a specific position.
    func assertStyle(x: Int, y: Int, _ style: Style, file: StaticString = #filePath, line: UInt = #line) {
        let cell = self[x, y]
        XCTAssertEqual(cell.style, style, "Cell (\(x), \(y)) style mismatch", file: file, line: line)
    }
}
