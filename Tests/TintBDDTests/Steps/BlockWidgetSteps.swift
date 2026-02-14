import PickleKit
import Tint

/// When steps for Block widget rendering.
struct BlockWidgetSteps: StepDefinitions {
    init() {}

    /// When I render a Block with plain/rounded/double/thick border
    let renderBlockWithBorder = StepDefinition.when(
        #"I render a Block with (plain|rounded|double|thick) border$"#
    ) { match in
        let ctx = TintTestContext.shared
        guard var buffer = ctx.buffer,
              let area = ctx.area else {
            throw TintStepError.setup("Buffer or area not initialized")
        }
        guard let border = TestData.borderStyle(named: match.captures[0]) else {
            throw TintStepError.setup("Unknown border style: \(match.captures[0])")
        }
        let block = Block(borderStyle: border)
        block.render(area: area, buffer: &buffer)
        ctx.buffer = buffer
    }

    /// When I render a Block with ... border and title "..."
    let renderBlockWithBorderAndTitle = StepDefinition.when(
        #"I render a Block with (plain|rounded|double|thick) border and title "([^"]*)""#
    ) { match in
        let ctx = TintTestContext.shared
        guard var buffer = ctx.buffer,
              let area = ctx.area else {
            throw TintStepError.setup("Buffer or area not initialized")
        }
        guard let border = TestData.borderStyle(named: match.captures[0]) else {
            throw TintStepError.setup("Unknown border style: \(match.captures[0])")
        }
        let title = match.captures[1]
        let block = Block(title: title, borderStyle: border)
        block.render(area: area, buffer: &buffer)
        ctx.buffer = buffer
    }

    /// When I render a Block with ... border containing text "..."
    let renderBlockWithBorderContainingText = StepDefinition.when(
        #"I render a Block with (plain|rounded|double|thick) border containing text "([^"]*)""#
    ) { match in
        let ctx = TintTestContext.shared
        guard var buffer = ctx.buffer,
              let area = ctx.area else {
            throw TintStepError.setup("Buffer or area not initialized")
        }
        guard let border = TestData.borderStyle(named: match.captures[0]) else {
            throw TintStepError.setup("Unknown border style: \(match.captures[0])")
        }
        let text = match.captures[1]
        let child = Text(text)
        let block = Block(borderStyle: border).containing(child)
        block.render(area: area, buffer: &buffer)
        ctx.buffer = buffer
    }
}
