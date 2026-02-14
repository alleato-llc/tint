# CLAUDE.md — Tint

## What This Is

A Swift TUI (Terminal User Interface) framework for building terminal applications. Provides a widget-based rendering system with buffers, layouts, styles, and composable widgets.

## Build & Test

```bash
# Build
swift build

# Test
swift test
swift test --filter TintBDDTests
swift test --filter TintTests
```

## Project Structure

```
Features/                      Gherkin feature files (project root)
├── buffer.feature
├── layout.feature
├── style_merging.feature
├── text_widget.feature
├── block_widget.feature
├── list_widget.feature
└── table_widget.feature

Sources/Tint/
├── Core/
│   ├── Buffer.swift           Grid of styled cells
│   ├── Cell.swift             Single character + style
│   └── Rect.swift             Position, Size, Rect types
├── Style/
│   ├── Color.swift            Color enum (named, ANSI256, RGB)
│   ├── Style.swift            Foreground, background, bold, italic, etc.
│   └── Theme.swift            Theme protocol + DefaultTheme
├── Layout/
│   ├── Constraint.swift       fixed, percentage, min, max, fill
│   └── Layout.swift           Splits Rect into sub-rects
├── Widget/
│   ├── Widget.swift           Widget protocol
│   ├── Text.swift             Text with alignment + styled spans
│   ├── Block.swift            Border wrapper with title
│   ├── List.swift             Scrollable list with selection
│   ├── Table.swift            Columnar data with headers
│   ├── Paragraph.swift        Word-wrapped text
│   ├── ProgressBar.swift      Progress indicator
│   ├── Gauge.swift            Label + bar + percentage
│   └── Composite.swift        ConditionalWidget, WidgetStack, Overlay
├── Terminal/
│   ├── ANSITerminal.swift     ANSI escape sequence backend
│   ├── InputReader.swift      Key input parsing
│   ├── Key.swift              Key enum
│   └── TerminalBackend.swift  Backend protocol
└── App/
    └── Application.swift      Main application loop

Tests/
├── TintTests/                 Unit tests (Swift Testing)
│   ├── Core/                  Buffer, Cell, Rect tests
│   ├── Widget/                Block, List, Table, Text tests
│   ├── Layout/                Constraint, Layout tests
│   ├── Style/                 Style, Theme tests
│   ├── App/                   Application tests
│   └── Helpers/               BufferAssertions, MockTerminalBackend
└── TintBDDTests/              BDD tests (PickleKit + Swift Testing)
    ├── TintBDDTests.swift     Runner
    ├── TintTestContext.swift   Shared state + error enum
    ├── TestData.swift          Factory helpers
    └── Steps/                  Step definitions
```

## Key Conventions

- **Swift 6.2+, macOS 14+**
- **Widgets are pure functions**: `render(area: Rect, buffer: inout Buffer)` — no side effects
- **Buffer is the universal output**: All widget testing is buffer content assertion
- **Dependencies**: PickleKit (BDD testing, test-only)
- **BDD tests** exercise the public rendering API — see [docs/testing/BDD.md](docs/testing/BDD.md)

## Documentation References

| Document | When to Read |
|----------|--------------|
| @docs/testing/BDD.md | BDD test suites, running, project-specific patterns |
| @docs/testing/PHILOSOPHY.md | Testing philosophy and why two test layers |
| @docs/testing/CONVENTIONS.md | Testing conventions, file organization, naming rules |
| @docs/testing/CI.md | CI configuration and running tests in pipelines |
| @CONTRIBUTING.md | Contribution guidelines and test requirements |
| @.claude/rules/bdd-conventions.md | BDD conventions for AI development (auto-loaded) |
