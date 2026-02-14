# Contributing to Tint

## Getting Started

```bash
git clone https://github.com/alleato-llc/tint.git
cd tint
swift build
swift test
```

Requirements: macOS 14+, Swift 6.2+.

## Making Changes

1. Fork the repository and create a branch from `main`
2. Make your changes
3. Add or update tests (see [Test Requirements](#test-requirements))
4. Ensure all tests pass: `swift test`
5. Open a pull request

## Test Requirements

**Every contribution must include tests.** Pull requests without adequate test coverage will not be merged.

### What Needs Tests

| Change Type | Required Tests |
|-------------|---------------|
| New widget | Unit tests for rendering + BDD feature file with scenarios |
| New core type (Buffer, Rect, etc.) | Unit tests for all public API + BDD scenarios for key behaviors |
| New layout constraint or direction | Unit tests + layout.feature scenarios |
| Bug fix | A test that reproduces the bug (fails before fix, passes after) |
| New public API method | Unit test covering expected behavior and edge cases |
| Style/theme changes | Unit tests for merge semantics |
| Refactoring (no behavior change) | Existing tests must continue to pass unchanged |

### Unit Tests (Swift Testing)

Add unit tests in `Tests/TintTests/` mirroring the source file structure. Use the buffer assertion helpers for readable failures:

```swift
@Test func myWidget() {
    let area = Rect(x: 0, y: 0, width: 10, height: 5)
    var buffer = Buffer(area: area)

    let widget = MyWidget(/* ... */)
    widget.render(area: area, buffer: &buffer)

    buffer.assertRow(0, equals: "expected  ")
}
```

### BDD Tests (PickleKit)

Add Gherkin scenarios in `Features/` for user-observable behavior. Each scenario should describe what a framework consumer would expect:

```gherkin
Feature: My Widget
  The MyWidget renders content with specific behavior.

  Scenario: Basic rendering
    Given a buffer of width 10 and height 5
    When I render the my widget with content "Hello"
    Then row 0 should contain "Hello"
```

Add corresponding step definitions in `Tests/TintBDDTests/Steps/` and register them in `TintBDDTests.swift`.

See [docs/testing/CONVENTIONS.md](docs/testing/CONVENTIONS.md) for detailed testing conventions.

### Running Tests

```bash
# Run all tests
swift test

# Run only unit tests
swift test --filter TintTests

# Run only BDD tests
swift test --filter TintBDDTests
```

## Code Style

- Follow existing patterns in the codebase
- Widgets conform to the `Widget` protocol with `func render(area: Rect, buffer: inout Buffer)`
- Keep widgets stateless — they are pure renderers
- Use value types (structs/enums) for core types
- Mark public types as `Sendable` where possible

## Project Structure

```
Sources/Tint/          # Framework source
Tests/TintTests/       # Unit tests (Swift Testing)
Tests/TintBDDTests/    # BDD tests (PickleKit)
Features/              # Gherkin feature files
docs/                  # Documentation
```

## Documentation

- [docs/testing/BDD.md](docs/testing/BDD.md) — BDD testing guide
- [docs/testing/PHILOSOPHY.md](docs/testing/PHILOSOPHY.md) — Why two test layers
- [docs/testing/CONVENTIONS.md](docs/testing/CONVENTIONS.md) — Testing conventions and patterns
- [docs/testing/CI.md](docs/testing/CI.md) — CI configuration
