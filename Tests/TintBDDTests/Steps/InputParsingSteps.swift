import PickleKit
@testable import Tint
import Testing

/// Given/When/Then steps for InputReader byte parsing.
struct InputParsingSteps: StepDefinitions {
    init() {}

    /// Given input bytes [97] or [27, 91, 65]
    let givenInputBytes = StepDefinition.given(
        #"input bytes \[([0-9, ]+)\]"#
    ) { match in
        let ctx = TintTestContext.shared
        ctx.inputBytes = match.captures[0]
            .split(separator: ",")
            .map { UInt8($0.trimmingCharacters(in: .whitespaces))! }
        ctx.parsedKeys = []
    }

    /// Given SGR mouse bytes for button 64 at 1,1
    let givenSGRMouseBytes = StepDefinition.given(
        #"SGR mouse bytes for button (\d+) at (\d+),(\d+)"#
    ) { match in
        let ctx = TintTestContext.shared
        let button = match.captures[0]
        let x = match.captures[1]
        let y = match.captures[2]
        // ESC [ < button ; x ; y M
        var bytes: [UInt8] = [27, 91, 60] // ESC [ <
        bytes.append(contentsOf: Array(button.utf8))
        bytes.append(59) // ;
        bytes.append(contentsOf: Array(x.utf8))
        bytes.append(59) // ;
        bytes.append(contentsOf: Array(y.utf8))
        bytes.append(77) // M (press)
        ctx.inputBytes = bytes
        ctx.parsedKeys = []
    }

    /// When the bytes are parsed
    let whenParsed = StepDefinition.when(
        #"the bytes are parsed"#
    ) { _ in
        let ctx = TintTestContext.shared
        var index = 0
        while index < ctx.inputBytes.count {
            let key = InputReader.parseKey(bytes: ctx.inputBytes, index: &index)
            ctx.parsedKeys.append(key)
        }
    }

    /// Then the parsed key should be char "a"
    let thenKeyIsChar = StepDefinition.then(
        #"the parsed key should be char "(.)""#
    ) { match in
        let ctx = TintTestContext.shared
        let ch = Character(match.captures[0])
        #expect(ctx.parsedKeys.count == 1)
        #expect(ctx.parsedKeys[0] == .char(ch))
    }

    /// Then the parsed key should be <keyName>
    let thenKeyIs = StepDefinition.then(
        #"the parsed key should be ([a-zA-Z0-9]+)$"#
    ) { match in
        let ctx = TintTestContext.shared
        let name = match.captures[0]
        guard let expected = keyFromName(name) else {
            throw TintStepError.setup("Unknown key name: \(name)")
        }
        #expect(ctx.parsedKeys.count == 1)
        #expect(ctx.parsedKeys[0] == expected)
    }

    /// Then N keys should be parsed
    let thenKeyCount = StepDefinition.then(
        #"(\d+) keys should be parsed"#
    ) { match in
        let ctx = TintTestContext.shared
        let count = Int(match.captures[0])!
        #expect(ctx.parsedKeys.count == count)
    }

    /// And parsed key N should be char "x"
    let thenKeyAtIndexIsChar = StepDefinition.then(
        #"parsed key (\d+) should be char "(.)""#
    ) { match in
        let ctx = TintTestContext.shared
        let index = Int(match.captures[0])!
        let ch = Character(match.captures[1])
        #expect(index < ctx.parsedKeys.count)
        #expect(ctx.parsedKeys[index] == .char(ch))
    }
}

private func keyFromName(_ name: String) -> Key? {
    switch name {
    case "enter": return .enter
    case "escape": return .escape
    case "backspace": return .backspace
    case "tab": return .tab
    case "up": return .up
    case "down": return .down
    case "left": return .left
    case "right": return .right
    case "home": return .home
    case "end": return .end
    case "pageUp": return .pageUp
    case "pageDown": return .pageDown
    case "delete": return .delete
    case "scrollUp": return .scrollUp
    case "scrollDown": return .scrollDown
    case "ctrlC": return .ctrlC
    case "unknown": return .unknown
    case "f1": return .f(1)
    case "f2": return .f(2)
    case "f3": return .f(3)
    case "f4": return .f(4)
    default: return nil
    }
}
