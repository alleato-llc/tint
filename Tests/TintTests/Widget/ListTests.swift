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
}
