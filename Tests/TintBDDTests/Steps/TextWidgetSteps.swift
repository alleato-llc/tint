import PickleKit
import Tint

/// When steps for Text widget rendering.
struct TextWidgetSteps: StepDefinitions {
    init() {}

    /// When I render a Text widget with content "..."
    let renderTextWidget = StepDefinition.when(
        #"I render a Text widget with content "([^"]*)""#
    ) { match in
        let ctx = TintTestContext.shared
        guard var buffer = ctx.buffer,
              let area = ctx.area else {
            throw TintStepError.setup("Buffer or area not initialized")
        }
        let content = match.captures[0]
        let widget = Text(content)
        widget.render(area: area, buffer: &buffer)
        ctx.buffer = buffer
    }

    /// When I render a Text widget with content "..." aligned center/right
    let renderTextWidgetAligned = StepDefinition.when(
        #"I render a Text widget with content "([^"]*)" aligned (left|center|right)"#
    ) { match in
        let ctx = TintTestContext.shared
        guard var buffer = ctx.buffer,
              let area = ctx.area else {
            throw TintStepError.setup("Buffer or area not initialized")
        }
        let content = match.captures[0]
        let alignmentStr = match.captures[1]
        let alignment: TextAlignment
        switch alignmentStr {
        case "center": alignment = .center
        case "right": alignment = .right
        default: alignment = .left
        }
        let widget = Text(content, alignment: alignment)
        widget.render(area: area, buffer: &buffer)
        ctx.buffer = buffer
    }

    /// When I render a Text widget with lines "..." and "..."
    let renderMultilineText = StepDefinition.when(
        #"I render a Text widget with lines "([^"]*)" and "([^"]*)""#
    ) { match in
        let ctx = TintTestContext.shared
        guard var buffer = ctx.buffer,
              let area = ctx.area else {
            throw TintStepError.setup("Buffer or area not initialized")
        }
        let content = match.captures[0] + "\n" + match.captures[1]
        let widget = Text(content)
        widget.render(area: area, buffer: &buffer)
        ctx.buffer = buffer
    }
}
