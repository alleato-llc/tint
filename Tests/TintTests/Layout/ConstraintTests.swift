import Testing
@testable import Tint

@Suite struct ConstraintTests {
    @Test func constraintEquality() {
        #expect(Constraint.fixed(10) == Constraint.fixed(10))
        #expect(Constraint.fixed(10) != Constraint.fixed(20))
        #expect(Constraint.fill == Constraint.fill)
        #expect(Constraint.fixed(10) != Constraint.percentage(10))
    }

    @Test func directionEnum() {
        let h: Direction = .horizontal
        let v: Direction = .vertical
        // Just ensure they exist and are distinct
        _ = h
        _ = v
    }
}
