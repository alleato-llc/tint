import XCTest
@testable import Tint

final class CellTests: XCTestCase {
    func testDefaultCell() {
        let cell = Cell()
        XCTAssertEqual(cell.character, " ")
        XCTAssertEqual(cell.style, .default)
    }

    func testEmptyCell() {
        XCTAssertEqual(Cell.empty.character, " ")
        XCTAssertEqual(Cell.empty.style, .default)
    }

    func testCellEquality() {
        let a = Cell(character: "A", style: Style(fg: .red))
        let b = Cell(character: "A", style: Style(fg: .red))
        let c = Cell(character: "B", style: Style(fg: .red))
        XCTAssertEqual(a, b)
        XCTAssertNotEqual(a, c)
    }

    func testReset() {
        var cell = Cell(character: "X", style: Style(fg: .green, bold: true))
        cell.reset()
        XCTAssertEqual(cell, .empty)
    }
}
