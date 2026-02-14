# Testing Conventions

Practical rules for writing tests in Tint.

## Unit Tests (Swift Testing)

### File Organization

```
Tests/TintTests/
├── Core/
│   ├── BufferTests.swift
│   ├── CellTests.swift
│   └── RectTests.swift
├── Widget/
│   ├── BlockTests.swift
│   ├── ListTests.swift
│   ├── TableTests.swift
│   └── TextTests.swift
├── Layout/
│   ├── ConstraintTests.swift
│   └── LayoutTests.swift
├── Style/
│   ├── StyleTests.swift
│   └── ThemeTests.swift
├── App/
│   └── ApplicationTests.swift
└── Helpers/
    ├── BufferAssertions.swift
    └── MockTerminalBackend.swift
```

Tests mirror the source directory structure. Each source file gets a corresponding test file.

### Buffer Assertion Helpers

Use the `Buffer` assertion extensions instead of raw `#expect` assertions:

```swift
buffer.assertRow(0, equals: "Hello     ")
buffer.assertCell(x: 3, y: 1, char: "X")
buffer.assertStyle(x: 0, y: 0, Style(fg: .red))
```

These provide better failure messages with actual vs expected content.

### Test Pattern

```swift
@Test func something() {
    // Arrange: create buffer + area
    let area = Rect(x: 0, y: 0, width: 10, height: 5)
    var buffer = Buffer(area: area)

    // Act: render widget
    let widget = Text("Hello")
    widget.render(area: area, buffer: &buffer)

    // Assert: check buffer content
    buffer.assertRow(0, equals: "Hello     ")
}
```

### What to Test

- **Public API**: Every public method, initializer, and computed property
- **Edge cases**: Empty areas, zero-width buffers, out-of-bounds access
- **Default values**: Verify default initializer parameters produce expected behavior
- **Equality**: Equatable/Hashable conformance where applicable

### What Not to Test

- Private implementation details (internal index calculations, etc.)
- The Swift compiler (type system guarantees)
- Trivial getters/setters with no logic

## BDD Tests (PickleKit)

### File Organization

```
Features/                          # Gherkin feature files (project root)
├── buffer.feature
├── layout.feature
├── style_merging.feature
├── text_widget.feature
├── block_widget.feature
├── list_widget.feature
└── table_widget.feature

Tests/TintBDDTests/
├── TintBDDTests.swift             # Runner
├── TintTestContext.swift          # Shared state + error enum
├── TestData.swift                 # Factory helpers
└── Steps/
    ├── CommonSetupSteps.swift     # Given: buffer/area/selection
    ├── BufferActionSteps.swift    # When: buffer operations
    ├── BufferVerificationSteps.swift # Then: buffer assertions
    ├── LayoutSteps.swift          # When/Then: layout splitting
    ├── StyleSetupSteps.swift      # Given/When: style creation + merge
    ├── StyleVerificationSteps.swift # Then: style assertions
    ├── TextWidgetSteps.swift      # When: Text rendering
    ├── BlockWidgetSteps.swift     # When: Block rendering
    ├── ListWidgetSteps.swift      # Given/When: list setup + render
    └── TableWidgetSteps.swift     # Given/When: table setup + render
```

### Step Definition Rules

- Each step is a `let` stored property with a `StepDefinition.given/when/then()` value
- Comment each step with `/// Given/When/Then <step text>`
- Access shared state via `let ctx = TintTestContext.shared`
- Use `TintStepError.setup(...)` for missing prerequisites, `.assertion(...)` for failed expectations
- Only `CommonSetupSteps.init()` calls `ctx.reset()`

### Feature File Rules

- Start with `Feature:` block and a 1-2 sentence description
- Write steps in natural language with quoted strings for values
- Use bare integers for numeric values
- One scenario per distinct behavior — don't combine unrelated assertions

### Adding a New Feature File

1. Create `Features/<name>.feature` with Gherkin scenarios
2. Create step definition files in `Tests/TintBDDTests/Steps/`
3. Register new step types in `TintBDDTests.swift`'s `test.run(stepDefinitions:)` array
4. Run `swift test --filter TintBDDTests` to verify

## Test Suites

| Suite | Framework | Test Count | Coverage |
|-------|-----------|------------|----------|
| `TintTests` | Swift Testing | 81 | Core types, widgets, layout, style, app lifecycle |
| `TintBDDTests` | PickleKit (Swift Testing) | 40 | Widget rendering behavior, layout splitting, style merging |

## Naming Conventions

- **Unit test methods**: `@Test func actionExpectedResult` (e.g., `writeTruncates`, `emptyArea`)
- **BDD scenarios**: Present-tense description of observable outcome (e.g., "Text truncated horizontally")
- **Step definitions**: `givenX`, `whenX`, `thenX` camelCase property names
- **Feature files**: `snake_case.feature` matching the domain (e.g., `text_widget.feature`)
