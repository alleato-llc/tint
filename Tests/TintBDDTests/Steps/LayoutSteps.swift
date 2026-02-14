import PickleKit
import Tint

/// When/Then steps for layout splitting and rect assertions.
struct LayoutSteps: StepDefinitions {
    init() {}

    /// When I split vertically with constraints: ...
    let splitVertically = StepDefinition.when(
        #"I split vertically with constraints: (.+)"#
    ) { match in
        let ctx = TintTestContext.shared
        guard let area = ctx.area else {
            throw TintStepError.setup("Area not initialized")
        }
        let constraints = try parseConstraints(match.captures[0])
        let layout = Layout(direction: .vertical, constraints: constraints)
        ctx.rects = layout.split(area)
    }

    /// When I split horizontally with constraints: ...
    let splitHorizontally = StepDefinition.when(
        #"I split horizontally with constraints: (.+)"#
    ) { match in
        let ctx = TintTestContext.shared
        guard let area = ctx.area else {
            throw TintStepError.setup("Area not initialized")
        }
        let constraints = try parseConstraints(match.captures[0])
        let layout = Layout(direction: .horizontal, constraints: constraints)
        ctx.rects = layout.split(area)
    }

    /// When I split vertically with no constraints
    let splitWithNoConstraints = StepDefinition.when(
        #"I split vertically with no constraints"#
    ) { _ in
        let ctx = TintTestContext.shared
        guard let area = ctx.area else {
            throw TintStepError.setup("Area not initialized")
        }
        let layout = Layout(direction: .vertical, constraints: [])
        ctx.rects = layout.split(area)
    }

    /// Then I should get N rects
    let shouldGetNRects = StepDefinition.then(
        #"I should get (\d+) rects?"#
    ) { match in
        let ctx = TintTestContext.shared
        let expected = Int(match.captures[0])!
        let actual = ctx.rects.count
        guard actual == expected else {
            throw TintStepError.assertion("Expected \(expected) rects but got \(actual)")
        }
    }

    /// Then rect N should have height M
    let rectShouldHaveHeight = StepDefinition.then(
        #"rect (\d+) should have height (\d+)"#
    ) { match in
        let ctx = TintTestContext.shared
        let index = Int(match.captures[0])!
        let expected = Int(match.captures[1])!
        guard index < ctx.rects.count else {
            throw TintStepError.assertion("Rect index \(index) out of bounds (count: \(ctx.rects.count))")
        }
        let actual = ctx.rects[index].height
        guard actual == expected else {
            throw TintStepError.assertion("Rect \(index) height expected \(expected) but got \(actual)")
        }
    }

    /// Then rect N should have width M
    let rectShouldHaveWidth = StepDefinition.then(
        #"rect (\d+) should have width (\d+)"#
    ) { match in
        let ctx = TintTestContext.shared
        let index = Int(match.captures[0])!
        let expected = Int(match.captures[1])!
        guard index < ctx.rects.count else {
            throw TintStepError.assertion("Rect index \(index) out of bounds (count: \(ctx.rects.count))")
        }
        let actual = ctx.rects[index].width
        guard actual == expected else {
            throw TintStepError.assertion("Rect \(index) width expected \(expected) but got \(actual)")
        }
    }

    /// Then all rects should have width N
    let allRectsShouldHaveWidth = StepDefinition.then(
        #"all rects should have width (\d+)"#
    ) { match in
        let ctx = TintTestContext.shared
        let expected = Int(match.captures[0])!
        for (i, rect) in ctx.rects.enumerated() {
            guard rect.width == expected else {
                throw TintStepError.assertion("Rect \(i) width expected \(expected) but got \(rect.width)")
            }
        }
    }

    /// Then rect N should equal the original area
    let rectShouldEqualOriginalArea = StepDefinition.then(
        #"rect (\d+) should equal the original area"#
    ) { match in
        let ctx = TintTestContext.shared
        let index = Int(match.captures[0])!
        guard let area = ctx.area else {
            throw TintStepError.setup("Area not initialized")
        }
        guard index < ctx.rects.count else {
            throw TintStepError.assertion("Rect index \(index) out of bounds")
        }
        let rect = ctx.rects[index]
        guard rect == area else {
            throw TintStepError.assertion("Rect \(index) (\(rect)) does not equal area (\(area))")
        }
    }
}

private func parseConstraints(_ text: String) throws -> [Constraint] {
    let parts = text.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    return try parts.map { part in
        if part == "fill" {
            return .fill
        } else if part.hasPrefix("fixed("), part.hasSuffix(")") {
            let value = String(part.dropFirst(6).dropLast(1))
            guard let n = Int(value) else {
                throw TintStepError.setup("Invalid fixed constraint: \(part)")
            }
            return .fixed(n)
        } else if part.hasPrefix("percentage("), part.hasSuffix(")") {
            let value = String(part.dropFirst(11).dropLast(1))
            guard let n = Int(value) else {
                throw TintStepError.setup("Invalid percentage constraint: \(part)")
            }
            return .percentage(n)
        } else if part.hasPrefix("min("), part.hasSuffix(")") {
            let value = String(part.dropFirst(4).dropLast(1))
            guard let n = Int(value) else {
                throw TintStepError.setup("Invalid min constraint: \(part)")
            }
            return .min(n)
        } else if part.hasPrefix("max("), part.hasSuffix(")") {
            let value = String(part.dropFirst(4).dropLast(1))
            guard let n = Int(value) else {
                throw TintStepError.setup("Invalid max constraint: \(part)")
            }
            return .max(n)
        } else {
            throw TintStepError.setup("Unknown constraint: \(part)")
        }
    }
}
