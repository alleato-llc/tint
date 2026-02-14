import Testing
import Tint

extension Buffer {
    /// Assert the text content of a specific row matches expected string (trimming trailing spaces).
    func assertRow(_ row: Int, equals expected: String, sourceLocation: SourceLocation = #_sourceLocation) {
        let actual = textAt(row: row)
        let trimmed = String(actual.reversed().drop(while: { $0 == " " }).reversed())
        #expect(trimmed == expected, "Row \(row) mismatch", sourceLocation: sourceLocation)
    }

    /// Assert the character at a specific position.
    func assertCell(x: Int, y: Int, char expected: Character, sourceLocation: SourceLocation = #_sourceLocation) {
        let cell = self[x, y]
        #expect(cell.character == expected, "Cell (\(x), \(y)) character mismatch", sourceLocation: sourceLocation)
    }

    /// Assert the style at a specific position.
    func assertStyle(x: Int, y: Int, _ style: Style, sourceLocation: SourceLocation = #_sourceLocation) {
        let cell = self[x, y]
        #expect(cell.style == style, "Cell (\(x), \(y)) style mismatch", sourceLocation: sourceLocation)
    }
}
