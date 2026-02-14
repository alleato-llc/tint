import PickleKit
import Tint

/// Given/When steps for style creation and merging.
struct StyleSetupSteps: StepDefinitions {
    init() {}

    /// Given a base style with foreground "color"
    let givenBaseStyleWithFg = StepDefinition.given(
        #"a base style with foreground "([^"]*)"$"#
    ) { match in
        let ctx = TintTestContext.shared
        guard let color = TestData.color(named: match.captures[0]) else {
            throw TintStepError.setup("Unknown color: \(match.captures[0])")
        }
        ctx.baseStyle = Style(fg: color)
    }

    /// Given a base style with foreground "color" and background "color"
    let givenBaseStyleWithFgAndBg = StepDefinition.given(
        #"a base style with foreground "([^"]*)" and background "([^"]*)""#
    ) { match in
        let ctx = TintTestContext.shared
        guard let fg = TestData.color(named: match.captures[0]) else {
            throw TintStepError.setup("Unknown color: \(match.captures[0])")
        }
        guard let bg = TestData.color(named: match.captures[1]) else {
            throw TintStepError.setup("Unknown color: \(match.captures[1])")
        }
        ctx.baseStyle = Style(fg: fg, bg: bg)
    }

    /// Given a base style with bold and italic
    let givenBaseStyleWithBoldAndItalic = StepDefinition.given(
        #"a base style with bold and italic"#
    ) { _ in
        let ctx = TintTestContext.shared
        ctx.baseStyle = Style(bold: true, italic: true)
    }

    /// Given a base style with default values
    let givenBaseDefaultStyle = StepDefinition.given(
        #"a base style with default values"#
    ) { _ in
        let ctx = TintTestContext.shared
        ctx.baseStyle = .default
    }

    /// Given an overlay style with foreground "color"
    let givenOverlayStyleWithFg = StepDefinition.given(
        #"an overlay style with foreground "([^"]*)"$"#
    ) { match in
        let ctx = TintTestContext.shared
        guard let color = TestData.color(named: match.captures[0]) else {
            throw TintStepError.setup("Unknown color: \(match.captures[0])")
        }
        ctx.overlayStyle = Style(fg: color)
    }

    /// Given an overlay style with default foreground
    let givenOverlayStyleWithDefaultFg = StepDefinition.given(
        #"an overlay style with default foreground"#
    ) { _ in
        let ctx = TintTestContext.shared
        ctx.overlayStyle = Style(fg: .default)
    }

    /// Given an overlay style with underline
    let givenOverlayStyleWithUnderline = StepDefinition.given(
        #"an overlay style with underline"#
    ) { _ in
        let ctx = TintTestContext.shared
        ctx.overlayStyle = Style(underline: true)
    }

    /// Given an overlay style with default values
    let givenOverlayDefaultStyle = StepDefinition.given(
        #"an overlay style with default values"#
    ) { _ in
        let ctx = TintTestContext.shared
        ctx.overlayStyle = .default
    }

    /// When I merge the overlay onto the base
    let mergeOverlayOntoBase = StepDefinition.when(
        #"I merge the overlay onto the base"#
    ) { _ in
        let ctx = TintTestContext.shared
        guard let base = ctx.baseStyle else {
            throw TintStepError.setup("Base style not initialized")
        }
        guard let overlay = ctx.overlayStyle else {
            throw TintStepError.setup("Overlay style not initialized")
        }
        ctx.mergedStyle = base.merging(overlay)
    }
}
