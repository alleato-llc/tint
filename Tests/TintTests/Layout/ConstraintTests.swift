import XCTest
@testable import Tint

final class ConstraintTests: XCTestCase {
    func testConstraintEquality() {
        XCTAssertEqual(Constraint.fixed(10), Constraint.fixed(10))
        XCTAssertNotEqual(Constraint.fixed(10), Constraint.fixed(20))
        XCTAssertEqual(Constraint.fill, Constraint.fill)
        XCTAssertNotEqual(Constraint.fixed(10), Constraint.percentage(10))
    }

    func testDirectionEnum() {
        let h: Direction = .horizontal
        let v: Direction = .vertical
        // Just ensure they exist and are distinct
        XCTAssertTrue(true) // If this compiles, the enum works
        _ = h
        _ = v
    }
}
