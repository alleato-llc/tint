import XCTest
@testable import Tint

final class LayoutTests: XCTestCase {
    func testVerticalSplit() {
        let area = Rect(x: 0, y: 0, width: 80, height: 24)
        let layout = Layout(direction: .vertical, constraints: [.fixed(3), .fill, .fixed(1)])
        let rects = layout.split(area)
        XCTAssertEqual(rects.count, 3)
        XCTAssertEqual(rects[0], Rect(x: 0, y: 0, width: 80, height: 3))
        XCTAssertEqual(rects[1], Rect(x: 0, y: 3, width: 80, height: 20))
        XCTAssertEqual(rects[2], Rect(x: 0, y: 23, width: 80, height: 1))
    }

    func testHorizontalSplit() {
        let area = Rect(x: 0, y: 0, width: 80, height: 24)
        let layout = Layout(direction: .horizontal, constraints: [.fixed(20), .fill])
        let rects = layout.split(area)
        XCTAssertEqual(rects.count, 2)
        XCTAssertEqual(rects[0], Rect(x: 0, y: 0, width: 20, height: 24))
        XCTAssertEqual(rects[1], Rect(x: 20, y: 0, width: 60, height: 24))
    }

    func testPercentageSplit() {
        let area = Rect(x: 0, y: 0, width: 100, height: 10)
        let layout = Layout(direction: .horizontal, constraints: [.percentage(30), .percentage(70)])
        let rects = layout.split(area)
        XCTAssertEqual(rects[0].width, 30)
        XCTAssertEqual(rects[1].width, 70)
    }

    func testMultipleFills() {
        let area = Rect(x: 0, y: 0, width: 100, height: 10)
        let layout = Layout(direction: .horizontal, constraints: [.fixed(10), .fill, .fill])
        let rects = layout.split(area)
        XCTAssertEqual(rects[0].width, 10)
        // 90 remaining split between 2 fills: 45 each
        XCTAssertEqual(rects[1].width, 45)
        XCTAssertEqual(rects[2].width, 45)
    }

    func testMinConstraint() {
        let area = Rect(x: 0, y: 0, width: 100, height: 10)
        let layout = Layout(direction: .horizontal, constraints: [.min(20), .fill])
        let rects = layout.split(area)
        // min(20) gets 20 initially + some fill share
        XCTAssertGreaterThanOrEqual(rects[0].width, 20)
    }

    func testEmptyConstraints() {
        let area = Rect(x: 0, y: 0, width: 80, height: 24)
        let layout = Layout(direction: .vertical, constraints: [])
        let rects = layout.split(area)
        XCTAssertTrue(rects.isEmpty)
    }

    func testSingleFill() {
        let area = Rect(x: 0, y: 0, width: 80, height: 24)
        let layout = Layout(direction: .vertical, constraints: [.fill])
        let rects = layout.split(area)
        XCTAssertEqual(rects.count, 1)
        XCTAssertEqual(rects[0], area)
    }
}
