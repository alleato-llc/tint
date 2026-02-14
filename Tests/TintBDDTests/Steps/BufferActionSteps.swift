import PickleKit
import Tint

/// When steps for buffer operations.
struct BufferActionSteps: StepDefinitions {
    init() {}

    /// When I write "..." at position (x, y)
    let writeAtPosition = StepDefinition.when(
        #"I write "([^"]*)" at position \((\d+), (\d+)\)"#
    ) { match in
        let ctx = TintTestContext.shared
        guard var buffer = ctx.buffer else {
            throw TintStepError.setup("Buffer not initialized")
        }
        let text = match.captures[0]
        let x = Int(match.captures[1])!
        let y = Int(match.captures[2])!
        buffer.write(text, x: x, y: y)
        ctx.buffer = buffer
    }

    /// When I fill the region (x, y, w, h) with "X"
    let fillRegion = StepDefinition.when(
        #"I fill the region \((\d+), (\d+), (\d+), (\d+)\) with "([^"]*)""#
    ) { match in
        let ctx = TintTestContext.shared
        guard var buffer = ctx.buffer else {
            throw TintStepError.setup("Buffer not initialized")
        }
        let x = Int(match.captures[0])!
        let y = Int(match.captures[1])!
        let w = Int(match.captures[2])!
        let h = Int(match.captures[3])!
        let char = Character(match.captures[4])
        let rect = Rect(x: x, y: y, width: w, height: h)
        buffer.fill(rect, cell: Cell(character: char))
        ctx.buffer = buffer
    }

    /// When I merge a buffer at (x, y) of width N containing "..."
    let mergeBuffer = StepDefinition.when(
        #"I merge a buffer at \((\d+), (\d+)\) of width (\d+) containing "([^"]*)""#
    ) { match in
        let ctx = TintTestContext.shared
        guard var buffer = ctx.buffer else {
            throw TintStepError.setup("Buffer not initialized")
        }
        let x = Int(match.captures[0])!
        let y = Int(match.captures[1])!
        let width = Int(match.captures[2])!
        let text = match.captures[3]
        var overlay = Buffer(area: Rect(x: x, y: y, width: width, height: 1))
        overlay.write(text, x: x, y: y)
        buffer.merge(overlay)
        ctx.buffer = buffer
    }

    /// When I reset the buffer
    let resetBuffer = StepDefinition.when(
        #"I reset the buffer"#
    ) { _ in
        let ctx = TintTestContext.shared
        guard var buffer = ctx.buffer else {
            throw TintStepError.setup("Buffer not initialized")
        }
        buffer.reset()
        ctx.buffer = buffer
    }
}
