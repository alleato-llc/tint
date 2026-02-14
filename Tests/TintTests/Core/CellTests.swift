import Testing
@testable import Tint

@Suite struct CellTests {
    @Test func defaultCell() {
        let cell = Cell()
        #expect(cell.character == " ")
        #expect(cell.style == .default)
    }

    @Test func emptyCell() {
        #expect(Cell.empty.character == " ")
        #expect(Cell.empty.style == .default)
    }

    @Test func cellEquality() {
        let a = Cell(character: "A", style: Style(fg: .red))
        let b = Cell(character: "A", style: Style(fg: .red))
        let c = Cell(character: "B", style: Style(fg: .red))
        #expect(a == b)
        #expect(a != c)
    }

    @Test func reset() {
        var cell = Cell(character: "X", style: Style(fg: .green, bold: true))
        cell.reset()
        #expect(cell == .empty)
    }
}
