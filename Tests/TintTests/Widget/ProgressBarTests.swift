import XCTest
@testable import Tint

final class ProgressBarTests: XCTestCase {
    func testEmptyProgressBar() {
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

    func testFullProgressBar() {
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

    func testHalfProgressBar() {
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

    func testNoBrackets() {
        let area = Rect(x: 0, y: 0, width: 10, height: 1)
        var buffer = Buffer(area: area)
        let bar = ProgressBar(progress: 1.0, showBrackets: false)
        bar.render(area: area, buffer: &buffer)
        // All cells should be filled, no brackets
        for x in 0..<10 {
            buffer.assertCell(x: x, y: 0, char: "█")
        }
    }

    func testProgressClampedAboveOne() {
        let bar = ProgressBar(progress: 1.5)
        XCTAssertEqual(bar.progress, 1.0)
    }

    func testProgressClampedBelowZero() {
        let bar = ProgressBar(progress: -0.5)
        XCTAssertEqual(bar.progress, 0.0)
    }
}
