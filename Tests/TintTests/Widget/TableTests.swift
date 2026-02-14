import XCTest
@testable import Tint

final class TableTests: XCTestCase {
    func testBasicTable() {
        let area = Rect(x: 0, y: 0, width: 30, height: 5)
        var buffer = Buffer(area: area)
        let table = Table(
            columns: [
                .init("Name", width: .fixed(10)),
                .init("Value", width: .fill),
            ],
            rows: [
                .init(["Alpha", "100"]),
                .init(["Beta", "200"]),
            ]
        )
        table.render(area: area, buffer: &buffer)
        // Header row
        buffer.assertCell(x: 0, y: 0, char: "N")
        // Separator
        buffer.assertCell(x: 0, y: 1, char: "─")
        // First data row
        buffer.assertCell(x: 0, y: 2, char: "A")
    }

    func testTableWithSelection() {
        let area = Rect(x: 0, y: 0, width: 20, height: 5)
        var buffer = Buffer(area: area)
        let table = Table(
            columns: [.init("Col", width: .fill)],
            rows: [.init(["Row 0"]), .init(["Row 1"])],
            selected: 1,
            highlightStyle: Style(fg: .black, bg: .white)
        )
        table.render(area: area, buffer: &buffer)
        // Selected row (index 1) is at y=3 (header=0, sep=1, row0=2, row1=3)
        XCTAssertEqual(buffer[0, 3].style, Style(fg: .black, bg: .white))
    }

    func testEmptyTable() {
        let area = Rect(x: 0, y: 0, width: 20, height: 5)
        var buffer = Buffer(area: area)
        let table = Table(columns: [], rows: [])
        table.render(area: area, buffer: &buffer)
        // Should not crash
    }

    func testTableColumnWidths() {
        let area = Rect(x: 0, y: 0, width: 21, height: 4)
        var buffer = Buffer(area: area)
        let table = Table(
            columns: [
                .init("#", width: .fixed(3)),
                .init("Title", width: .fill),
                .init("Duration", width: .fixed(8)),
            ],
            rows: [.init(["1", "Song Name", "3:42"])],
            columnSpacing: 1
        )
        table.render(area: area, buffer: &buffer)
        // Header should have all columns
        let headerText = buffer.textAt(row: 0)
        XCTAssertTrue(headerText.contains("#"))
        XCTAssertTrue(headerText.contains("Title"))
        XCTAssertTrue(headerText.contains("Duration"))
    }
}
