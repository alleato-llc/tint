import XCTest
@testable import Tint

final class ListTests: XCTestCase {
    func testBasicList() {
        let area = Rect(x: 0, y: 0, width: 20, height: 3)
        var buffer = Buffer(area: area)
        let list = ListWidget(items: [
            .init("Item One"),
            .init("Item Two"),
            .init("Item Three"),
        ])
        list.render(area: area, buffer: &buffer)
        buffer.assertRow(0, equals: "  Item One")
        buffer.assertRow(1, equals: "  Item Two")
        buffer.assertRow(2, equals: "  Item Three")
    }

    func testListWithSelection() {
        let area = Rect(x: 0, y: 0, width: 20, height: 3)
        var buffer = Buffer(area: area)
        let list = ListWidget(
            items: [.init("A"), .init("B"), .init("C")],
            selected: 1
        )
        list.render(area: area, buffer: &buffer)
        // Selected item should have highlight symbol
        buffer.assertCell(x: 0, y: 1, char: ">")
    }

    func testListScrolling() {
        let area = Rect(x: 0, y: 0, width: 20, height: 2)
        var buffer = Buffer(area: area)
        let items = (0..<10).map { ListWidget.Item("Item \($0)") }
        let list = ListWidget(items: items, selected: 8)
        list.render(area: area, buffer: &buffer)
        // With selection at 8 and only 2 visible rows, should scroll
        let text = buffer.allText()
        XCTAssertTrue(text.contains { $0.contains("Item 8") })
    }

    func testEmptyList() {
        let area = Rect(x: 0, y: 0, width: 20, height: 3)
        var buffer = Buffer(area: area)
        let list = ListWidget(items: [])
        list.render(area: area, buffer: &buffer)
        // Should not crash, buffer should be empty
        buffer.assertRow(0, equals: "")
    }

    func testListTruncation() {
        let area = Rect(x: 0, y: 0, width: 8, height: 1)
        var buffer = Buffer(area: area)
        let list = ListWidget(items: [.init("Very Long Item Name")])
        list.render(area: area, buffer: &buffer)
        // Item text truncated (8 - 2 for padding = 6 chars max)
        let text = buffer.textAt(row: 0)
        XCTAssertEqual(text.count, 8)
    }

    func testHorizontalOffset() {
        let area = Rect(x: 0, y: 0, width: 12, height: 1)
        var buffer = Buffer(area: area)
        let list = ListWidget(
            items: [.init("Hello World Long Text")],
            horizontalOffset: 6
        )
        list.render(area: area, buffer: &buffer)
        // "Hello World Long Text" shifted by 6 = "World Long Text", truncated to 10 (12 - 2 symbol)
        buffer.assertRow(0, equals: "  World Long")
    }

    func testHorizontalOffsetWithSelection() {
        let area = Rect(x: 0, y: 0, width: 12, height: 1)
        var buffer = Buffer(area: area)
        let list = ListWidget(
            items: [.init("Hello World Long Text")],
            selected: 0,
            horizontalOffset: 6
        )
        list.render(area: area, buffer: &buffer)
        // Symbol "> " stays, text shifts
        buffer.assertCell(x: 0, y: 0, char: ">")
        buffer.assertCell(x: 2, y: 0, char: "W")
    }

    func testHorizontalOffsetZero() {
        let area = Rect(x: 0, y: 0, width: 20, height: 1)
        var buffer = Buffer(area: area)
        let list = ListWidget(
            items: [.init("Short")],
            horizontalOffset: 0
        )
        list.render(area: area, buffer: &buffer)
        buffer.assertRow(0, equals: "  Short")
    }

    func testHorizontalOffsetBeyondText() {
        let area = Rect(x: 0, y: 0, width: 20, height: 1)
        var buffer = Buffer(area: area)
        let list = ListWidget(
            items: [.init("Hi")],
            horizontalOffset: 100
        )
        list.render(area: area, buffer: &buffer)
        // All text scrolled away, just the padding remains
        buffer.assertRow(0, equals: "")
    }
}
