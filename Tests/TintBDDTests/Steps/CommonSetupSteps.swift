import PickleKit
import Tint

/// Given steps for tint BDD scenarios.
struct CommonSetupSteps: StepDefinitions {
    init() {
        let ctx = TintTestContext.shared
        ctx.reset()
    }

    /// Given a buffer of width N and height M
    let givenBuffer = StepDefinition.given(
        #"a buffer of width (\d+) and height (\d+)"#
    ) { match in
        let ctx = TintTestContext.shared
        let width = Int(match.captures[0])!
        let height = Int(match.captures[1])!
        ctx.buffer = TestData.buffer(width: width, height: height)
        ctx.area = TestData.area(width: width, height: height)
    }

    /// Given an area of width N and height M
    let givenArea = StepDefinition.given(
        #"an area of width (\d+) and height (\d+)"#
    ) { match in
        let ctx = TintTestContext.shared
        let width = Int(match.captures[0])!
        let height = Int(match.captures[1])!
        ctx.area = TestData.area(width: width, height: height)
        if ctx.buffer == nil {
            ctx.buffer = TestData.buffer(width: width, height: height)
        }
    }

    /// Given the selected index is N
    let givenSelectedIndex = StepDefinition.given(
        #"the selected index is (\d+)"#
    ) { match in
        let ctx = TintTestContext.shared
        ctx.selectedIndex = Int(match.captures[0])!
    }
}
