import Testing
@testable import Tint

@Suite struct ProgressBarTests {
    @Test func emptyProgressBar() {
        let area = Rect(x: 0, y: 0, width: 12, height: 1)
        var buffer = Buffer(area: area)
        let bar = ProgressBar(progress: 0.0)
        bar.render(area: area, buffer: &buffer)
        buffer.assertCell(x: 0, y: 0, char: "[")
        buffer.assertCell(x: 11, y: 0, char: "]")
        // All interior should be empty char
        for x in 1...10 {
            buffer.assertCell(x: x, y: 0, char: "░")
        }
    }

    @Test func fullProgressBar() {
        let area = Rect(x: 0, y: 0, width: 12, height: 1)
        var buffer = Buffer(area: area)
        let bar = ProgressBar(progress: 1.0)
        bar.render(area: area, buffer: &buffer)
        buffer.assertCell(x: 0, y: 0, char: "[")
        buffer.assertCell(x: 11, y: 0, char: "]")
        for x in 1...10 {
            buffer.assertCell(x: x, y: 0, char: "█")
        }
    }

    @Test func halfProgressBar() {
        let area = Rect(x: 0, y: 0, width: 12, height: 1)
        var buffer = Buffer(area: area)
        let bar = ProgressBar(progress: 0.5)
        bar.render(area: area, buffer: &buffer)
        // 10 interior cells, 50% = 5 filled
        for x in 1...5 {
            buffer.assertCell(x: x, y: 0, char: "█")
        }
        for x in 6...10 {
            buffer.assertCell(x: x, y: 0, char: "░")
        }
    }

    @Test func noBrackets() {
        let area = Rect(x: 0, y: 0, width: 10, height: 1)
        var buffer = Buffer(area: area)
        let bar = ProgressBar(progress: 1.0, showBrackets: false)
        bar.render(area: area, buffer: &buffer)
        // All cells should be filled, no brackets
        for x in 0..<10 {
            buffer.assertCell(x: x, y: 0, char: "█")
        }
    }

    @Test func progressClampedAboveOne() {
        let bar = ProgressBar(progress: 1.5)
        #expect(bar.progress == 1.0)
    }

    @Test func progressClampedBelowZero() {
        let bar = ProgressBar(progress: -0.5)
        #expect(bar.progress == 0.0)
    }
}
