import PickleKit
import Tint

/// Then steps for buffer content assertions.
struct BufferVerificationSteps: StepDefinitions {
    init() {}

    /// Then row N should contain "..."
    let rowShouldContain = StepDefinition.then(
        #"row (\d+) should contain "([^"]*)""#
    ) { match in
        let ctx = TintTestContext.shared
        guard let buffer = ctx.buffer else {
            throw TintStepError.setup("Buffer not initialized")
        }
        let row = Int(match.captures[0])!
        let expected = match.captures[1]
        let actual = buffer.textAt(row: row)
        guard actual.contains(expected) else {
            throw TintStepError.assertion("Row \(row) does not contain \"\(expected)\". Actual: \"\(actual)\"")
        }
    }

    /// Then row N should be exactly "..."
    let rowShouldBeExactly = StepDefinition.then(
        #"row (\d+) should be exactly "([^"]*)""#
    ) { match in
        let ctx = TintTestContext.shared
        guard let buffer = ctx.buffer else {
            throw TintStepError.setup("Buffer not initialized")
        }
        let row = Int(match.captures[0])!
        let expected = match.captures[1]
        let actual = buffer.textAt(row: row)
        guard actual == expected else {
            throw TintStepError.assertion("Row \(row) expected \"\(expected)\" but got \"\(actual)\"")
        }
    }

    /// Then cell (x, y) should contain "C"
    let cellShouldContain = StepDefinition.then(
        #"cell \((\d+), (\d+)\) should contain "([^"]*)""#
    ) { match in
        let ctx = TintTestContext.shared
        guard let buffer = ctx.buffer else {
            throw TintStepError.setup("Buffer not initialized")
        }
        let x = Int(match.captures[0])!
        let y = Int(match.captures[1])!
        let expected = Character(match.captures[2])
        let actual = buffer[x, y].character
        guard actual == expected else {
            throw TintStepError.assertion("Cell (\(x),\(y)) expected '\(expected)' but got '\(actual)'")
        }
    }

    /// Then the buffer does not crash
    let bufferDoesNotCrash = StepDefinition.then(
        #"the buffer does not crash"#
    ) { _ in
        // If we reach this step, no crash occurred
    }

    /// Then the buffer should contain text "..."
    let bufferShouldContainText = StepDefinition.then(
        #"the buffer should contain text "([^"]*)""#
    ) { match in
        let ctx = TintTestContext.shared
        guard let buffer = ctx.buffer else {
            throw TintStepError.setup("Buffer not initialized")
        }
        let expected = match.captures[0]
        let allText = buffer.allText().joined()
        guard allText.contains(expected) else {
            throw TintStepError.assertion("Buffer does not contain \"\(expected)\". Content: \(buffer.allText())")
        }
    }

    /// Then all rows should be blank
    let allRowsShouldBeBlank = StepDefinition.then(
        #"all rows should be blank"#
    ) { _ in
        let ctx = TintTestContext.shared
        guard let buffer = ctx.buffer else {
            throw TintStepError.setup("Buffer not initialized")
        }
        for row in 0..<buffer.area.height {
            let text = buffer.textAt(row: row)
            let trimmed = text.trimmingCharacters(in: .whitespaces)
            guard trimmed.isEmpty else {
                throw TintStepError.assertion("Row \(row) is not blank: \"\(text)\"")
            }
        }
    }
}
