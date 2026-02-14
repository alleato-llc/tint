# BDD Testing

Tint uses [PickleKit](https://github.com/alleato-llc/pickle-kit) for behavior-driven testing. Feature files describe widget rendering, layout splitting, and style merging behavior in Gherkin. Step definitions exercise Tint's public API and assert on buffer output.

Since Tint is a rendering framework, widgets are pure functions `(Rect, inout Buffer) -> Void` — testing buffer output IS behavioral testing.

## Test Suites

| Suite | Target | Scenarios | Coverage |
|-------|--------|-----------|----------|
| `TintBDDTests` | TintBDDTests | 40 | Buffer operations, layout splitting, style merging, Text/Block/List/Table widget rendering |

## Running

```bash
# Run BDD tests only
swift test --filter TintBDDTests

# Run all tests (unit + BDD)
swift test

# Run a single scenario by name
CUCUMBER_SCENARIOS="Write text to buffer" swift test --filter TintBDDTests
```

## Structure

```
Features/
├── buffer.feature           # Buffer write, fill, merge, reset, out-of-bounds
├── layout.feature           # Layout splitting with constraints
├── style_merging.feature    # Style merge semantics (override, OR booleans)
├── text_widget.feature      # Text alignment, truncation, multi-line
├── block_widget.feature     # Block borders, titles, child rendering
├── list_widget.feature      # ListWidget items, selection, scrolling
└── table_widget.feature     # Table headers, rows, selection

Tests/TintBDDTests/
├── TintBDDTests.swift           # Runner (@Suite(.serialized))
├── TintTestContext.swift        # Shared mutable state + TintStepError
├── TestData.swift               # Factory helpers (area, buffer, color, borderStyle)
└── Steps/
    ├── CommonSetupSteps.swift       # Given: buffer/area creation, selected index
    ├── BufferActionSteps.swift      # When: write, fill, merge, reset
    ├── BufferVerificationSteps.swift # Then: row/cell content assertions
    ├── LayoutSteps.swift            # When/Then: split + rect assertions
    ├── StyleSetupSteps.swift        # Given/When: style creation + merge
    ├── StyleVerificationSteps.swift # Then: merged style assertions
    ├── TextWidgetSteps.swift        # When: Text widget render
    ├── BlockWidgetSteps.swift       # When: Block widget render
    ├── ListWidgetSteps.swift        # Given/When: list setup + render
    └── TableWidgetSteps.swift       # Given/When: table setup + render
```

## Testing Boundaries

Tint's BDD tests exercise the **public rendering API** — widgets, buffers, layout, and styles. Terminal I/O (`ANSITerminal`, `InputReader`) and `Application` lifecycle are not covered by BDD tests since they require real terminal state. Those are covered by unit tests (Swift Testing) with `MockTerminalBackend`.
