import Testing
@testable import Tint

@Suite struct BlockTests {
    @Test func borderRendering() {
        let area = Rect(x: 0, y: 0, width: 5, height: 3)
        var buffer = Buffer(area: area)
        let block = Block(borderStyle: .plain)
        block.render(area: area, buffer: &buffer)
        buffer.assertCell(x: 0, y: 0, char: "┌")
        buffer.assertCell(x: 4, y: 0, char: "┐")
        buffer.assertCell(x: 0, y: 2, char: "└")
        buffer.assertCell(x: 4, y: 2, char: "┘")
        buffer.assertCell(x: 1, y: 0, char: "─")
        buffer.assertCell(x: 0, y: 1, char: "│")
    }

    @Test func roundedBorder() {
        let area = Rect(x: 0, y: 0, width: 5, height: 3)
        var buffer = Buffer(area: area)
        let block = Block(borderStyle: .rounded)
        block.render(area: area, buffer: &buffer)
        buffer.assertCell(x: 0, y: 0, char: "╭")
        buffer.assertCell(x: 4, y: 0, char: "╮")
        buffer.assertCell(x: 0, y: 2, char: "╰")
        buffer.assertCell(x: 4, y: 2, char: "╯")
    }

    @Test func title() {
        let area = Rect(x: 0, y: 0, width: 20, height: 3)
        var buffer = Buffer(area: area)
        let block = Block(title: "Test", borderStyle: .plain)
        block.render(area: area, buffer: &buffer)
        // Title should appear after corner: "┌ Test ─────┐"
        buffer.assertCell(x: 3, y: 0, char: "T")
        buffer.assertCell(x: 4, y: 0, char: "e")
        buffer.assertCell(x: 5, y: 0, char: "s")
        buffer.assertCell(x: 6, y: 0, char: "t")
    }

    @Test func childRendering() {
        let area = Rect(x: 0, y: 0, width: 10, height: 3)
        var buffer = Buffer(area: area)
        let block = Block(borderStyle: .plain)
            .containing(Text("Hi"))
        block.render(area: area, buffer: &buffer)
        // "Hi" should be inside the border at (1, 1)
        buffer.assertCell(x: 1, y: 1, char: "H")
        buffer.assertCell(x: 2, y: 1, char: "i")
    }

    @Test func doubleBorder() {
        let area = Rect(x: 0, y: 0, width: 5, height: 3)
        var buffer = Buffer(area: area)
        let block = Block(borderStyle: .double)
        block.render(area: area, buffer: &buffer)
        buffer.assertCell(x: 0, y: 0, char: "╔")
        buffer.assertCell(x: 4, y: 0, char: "╗")
        buffer.assertCell(x: 1, y: 0, char: "═")
        buffer.assertCell(x: 0, y: 1, char: "║")
    }

    @Test func emptyArea() {
        let area = Rect(x: 0, y: 0, width: 0, height: 0)
        var buffer = Buffer(area: area)
        let block = Block()
        block.render(area: area, buffer: &buffer)
        // Should not crash
    }
}
