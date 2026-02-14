import PickleKit
import Tint

/// Then steps for merged style assertions.
struct StyleVerificationSteps: StepDefinitions {
    init() {}

    /// Then the merged foreground should be "color"
    let mergedFgShouldBe = StepDefinition.then(
        #"the merged foreground should be "([^"]*)""#
    ) { match in
        let ctx = TintTestContext.shared
        guard let merged = ctx.mergedStyle else {
            throw TintStepError.setup("Merged style not initialized")
        }
        guard let expected = TestData.color(named: match.captures[0]) else {
            throw TintStepError.setup("Unknown color: \(match.captures[0])")
        }
        guard merged.fg == expected else {
            throw TintStepError.assertion("Merged foreground expected \(expected) but got \(merged.fg)")
        }
    }

    /// Then the merged background should be "color"
    let mergedBgShouldBe = StepDefinition.then(
        #"the merged background should be "([^"]*)""#
    ) { match in
        let ctx = TintTestContext.shared
        guard let merged = ctx.mergedStyle else {
            throw TintStepError.setup("Merged style not initialized")
        }
        guard let expected = TestData.color(named: match.captures[0]) else {
            throw TintStepError.setup("Unknown color: \(match.captures[0])")
        }
        guard merged.bg == expected else {
            throw TintStepError.assertion("Merged background expected \(expected) but got \(merged.bg)")
        }
    }

    /// Then the merged style should have bold enabled
    let mergedShouldHaveBold = StepDefinition.then(
        #"the merged style should have bold enabled"#
    ) { _ in
        let ctx = TintTestContext.shared
        guard let merged = ctx.mergedStyle else {
            throw TintStepError.setup("Merged style not initialized")
        }
        guard merged.bold else {
            throw TintStepError.assertion("Expected bold to be enabled")
        }
    }

    /// Then the merged style should have italic enabled
    let mergedShouldHaveItalic = StepDefinition.then(
        #"the merged style should have italic enabled"#
    ) { _ in
        let ctx = TintTestContext.shared
        guard let merged = ctx.mergedStyle else {
            throw TintStepError.setup("Merged style not initialized")
        }
        guard merged.italic else {
            throw TintStepError.assertion("Expected italic to be enabled")
        }
    }

    /// Then the merged style should have underline enabled
    let mergedShouldHaveUnderline = StepDefinition.then(
        #"the merged style should have underline enabled"#
    ) { _ in
        let ctx = TintTestContext.shared
        guard let merged = ctx.mergedStyle else {
            throw TintStepError.setup("Merged style not initialized")
        }
        guard merged.underline else {
            throw TintStepError.assertion("Expected underline to be enabled")
        }
    }

    /// Then the merged style should equal the default style
    let mergedShouldEqualDefault = StepDefinition.then(
        #"the merged style should equal the default style"#
    ) { _ in
        let ctx = TintTestContext.shared
        guard let merged = ctx.mergedStyle else {
            throw TintStepError.setup("Merged style not initialized")
        }
        guard merged == .default else {
            throw TintStepError.assertion("Expected default style but got \(merged)")
        }
    }
}
