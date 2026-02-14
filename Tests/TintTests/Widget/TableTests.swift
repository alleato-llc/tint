import Testing
@testable import Tint

@Suite struct TableTests {
    @Test func basicTable() {
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

    @Test func tableWithSelection() {
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
        #expect(buffer[0, 3].style == Style(fg: .black, bg: .white))
    }

    @Test func emptyTable() {
        let area = Rect(x: 0, y: 0, width: 20, height: 5)
        var buffer = Buffer(area: area)
        let table = Table(columns: [], rows: [])
        table.render(area: area, buffer: &buffer)
        // Should not crash
    }

    @Test func horizontalOffset() {
        let area = Rect(x: 0, y: 0, width: 20, height: 4)
        var buffer = Buffer(area: area)
        let table = Table(
            columns: [.init("Name", width: .fill)],
            rows: [.init(["Hello World Long Name"])],
            horizontalOffset: 6
        )
        table.render(area: area, buffer: &buffer)
        // Row "Hello World Long Name" shifted by 6 = "World Long Name"
        let rowText = buffer.textAt(row: 2)
        #expect(rowText.hasPrefix("World"))
    }

    @Test func horizontalOffsetZero() {
        let area = Rect(x: 0, y: 0, width: 20, height: 4)
        var buffer = Buffer(area: area)
        let table = Table(
            columns: [.init("Title", width: .fill)],
            rows: [.init(["Song"])],
            horizontalOffset: 0
        )
        table.render(area: area, buffer: &buffer)
        let headerText = buffer.textAt(row: 0)
        #expect(headerText.hasPrefix("Title"))
        let rowText = buffer.textAt(row: 2)
        #expect(rowText.hasPrefix("Song"))
    }

    @Test func tableColumnWidths() {
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
        #expect(headerText.contains("#"))
        #expect(headerText.contains("Title"))
        #expect(headerText.contains("Duration"))
    }
}
