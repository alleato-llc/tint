import XCTest
@testable import Tint

final class RectTests: XCTestCase {
    func testBasicProperties() {
        let rect = Rect(x: 1, y: 2, width: 10, height: 5)
        XCTAssertEqual(rect.right, 11)
        XCTAssertEqual(rect.bottom, 7)
        XCTAssertEqual(rect.area, 50)
        XCTAssertFalse(rect.isEmpty)
        XCTAssertEqual(rect.position, Position(x: 1, y: 2))
        XCTAssertEqual(rect.size, Size(width: 10, height: 5))
    }

    func testIsEmpty() {
        XCTAssertTrue(Rect(x: 0, y: 0, width: 0, height: 5).isEmpty)
        XCTAssertTrue(Rect(x: 0, y: 0, width: 5, height: 0).isEmpty)
        XCTAssertTrue(Rect.zero.isEmpty)
    }

    func testIntersection() {
        let a = Rect(x: 0, y: 0, width: 10, height: 10)
        let b = Rect(x: 5, y: 5, width: 10, height: 10)
        let inter = a.intersection(b)
        XCTAssertEqual(inter, Rect(x: 5, y: 5, width: 5, height: 5))
    }

    func testIntersectionNoOverlap() {
        let a = Rect(x: 0, y: 0, width: 5, height: 5)
        let b = Rect(x: 10, y: 10, width: 5, height: 5)
        let inter = a.intersection(b)
        XCTAssertTrue(inter.isEmpty)
    }

    func testContains() {
        let rect = Rect(x: 0, y: 0, width: 10, height: 10)
        XCTAssertTrue(rect.contains(Position(x: 0, y: 0)))
        XCTAssertTrue(rect.contains(Position(x: 9, y: 9)))
        XCTAssertFalse(rect.contains(Position(x: 10, y: 0)))
        XCTAssertFalse(rect.contains(Position(x: 0, y: 10)))
        XCTAssertFalse(rect.contains(Position(x: -1, y: 0)))
    }

    func testInset() {
        let rect = Rect(x: 0, y: 0, width: 20, height: 10)
        let inset = rect.inset(top: 1, right: 2, bottom: 1, left: 2)
        XCTAssertEqual(inset, Rect(x: 2, y: 1, width: 16, height: 8))
    }

    func testInner() {
        let rect = Rect(x: 0, y: 0, width: 10, height: 5)
        let inner = rect.inner
        XCTAssertEqual(inner, Rect(x: 1, y: 1, width: 8, height: 3))
    }

    func testInsetClamps() {
        let rect = Rect(x: 0, y: 0, width: 2, height: 2)
        let inset = rect.inset(top: 5, right: 5, bottom: 5, left: 5)
        XCTAssertEqual(inset.width, 0)
        XCTAssertEqual(inset.height, 0)
    }

    func testSizeZero() {
        XCTAssertEqual(Size.zero, Size(width: 0, height: 0))
    }
}
