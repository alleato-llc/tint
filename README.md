# Tint

A ratatui-inspired immediate-mode TUI framework for Swift. Zero dependencies beyond Foundation.

## Installation

Add Tint as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(path: "../tint"), // local
    // or: .package(url: "https://github.com/alleato-llc/tint.git", from: "0.1.0"),
]
```

Then add it to your target:

```swift
.executableTarget(
    name: "MyApp",
    dependencies: ["Tint"]
)
```

## Quick Start

```swift
import Tint

let app = Application()

var count = 0

app.run(render: { area, buffer in
    let text = Text("Hello, TUI! Count: \(count)", style: Style(fg: .cyan, bold: true))
    text.render(area: area, buffer: &buffer)
}, onKey: { key in
    switch key {
    case .char("q"), .ctrlC: app.quit()
    case .char(" "): count += 1
    default: break
    }
})
```

## Requirements

- macOS 14+
- Swift 6.2+

## Architecture

See [docs/architecture.md](docs/architecture.md) for a detailed design overview covering the rendering pipeline, core types, layout system, widget protocol, and terminal abstraction.

## Widget Catalog

### Text

Single or multi-line text with alignment and styled spans.

```swift
// Simple
Text("Hello", style: Style(fg: .green))

// Aligned
Text("Centered", alignment: .center)

// Styled spans
Text(lines: [
    TextLine([
        StyledSpan("Error: ", style: Style(fg: .red, bold: true)),
        StyledSpan("file not found", style: Style(fg: .white)),
    ])
])
```

### Paragraph

Word-wrapped text block.

```swift
Paragraph("This is a long paragraph that will automatically wrap at word boundaries.", style: Style(fg: .white))
```

### List

Scrollable list with selection highlight and auto-scrolling.

```swift
ListWidget(
    items: albums.map { .init($0.name) },
    selected: selectedIndex,
    highlightStyle: Style(fg: .black, bg: .cyan, bold: true),
    highlightSymbol: "> "
)
```

### Table

Columnar data with headers, row selection, and configurable column widths.

```swift
Table(
    columns: [
        .init("#", width: .fixed(3)),
        .init("Title", width: .fill),
        .init("Duration", width: .fixed(8)),
    ],
    rows: tracks.map { .init(["\($0.number)", $0.title, $0.duration]) },
    selected: selectedTrack
)
```

### ProgressBar

Horizontal progress indicator with customizable characters and styles.

```swift
ProgressBar(
    progress: 0.65,
    filledChar: "█",
    emptyChar: "░",
    filledStyle: Style(fg: .cyan),
    showBrackets: true
)
```

### Block

Border wrapper with optional title. Wraps any widget.

```swift
Block(title: "Library", borderStyle: .rounded, style: Style(fg: .brightBlack))
    .containing(myListWidget)
```

Border styles: `.plain`, `.rounded`, `.double`, `.thick`

### Gauge

Labeled progress bar combining text, bar, and percentage.

```swift
Gauge(label: "Loading", progress: 0.42, barStyle: Style(fg: .green))
```

## Layout

Split areas into sub-regions using constraints:

```swift
// Vertical: header (3 rows), content (fills), footer (1 row)
let sections = Layout(direction: .vertical, constraints: [
    .fixed(3), .fill, .fixed(1)
]).split(area)

// Horizontal: sidebar (20 cols), main content (fills)
let columns = Layout(direction: .horizontal, constraints: [
    .fixed(20), .fill
]).split(sections[1])
```

Constraint types:
- `.fixed(n)` — exact size
- `.percentage(n)` — percentage of total
- `.min(n)` — at least n, participates in fill distribution
- `.max(n)` — at most n, participates in fill distribution
- `.fill` — takes remaining space equally

## Theming

Create custom themes by conforming to the `Theme` protocol:

```swift
struct MyTheme: Theme {
    var primary: Style { Style(fg: .white) }
    var secondary: Style { Style(fg: .brightBlack) }
    var highlight: Style { Style(fg: .black, bg: .cyan, bold: true) }
    var accent: Style { Style(fg: .green, bold: true) }
    var muted: Style { Style(fg: .brightBlack, dim: true) }
    var border: Style { Style(fg: .brightBlack) }
    var title: Style { Style(fg: .white, bold: true) }
    var error: Style { Style(fg: .red, bold: true) }
    var statusBar: Style { Style(fg: .white, bg: .brightBlack) }
}

let app = Application(theme: MyTheme())
```

Access the theme in your render closure via `app.theme`.

## Extending Tint

### Custom Widgets

Conform to `Widget` and render directly into the buffer:

```swift
struct Sparkline: Widget {
    let data: [Double]

    func render(area: Rect, buffer: inout Buffer) {
        let blocks = ["▁","▂","▃","▄","▅","▆","▇","█"]
        guard let maxVal = data.max(), maxVal > 0 else { return }
        for (i, value) in data.enumerated() {
            guard area.x + i < area.right else { break }
            let idx = Int((value / maxVal) * Double(blocks.count - 1))
            let char = Character(blocks[idx])
            buffer[area.x + i, area.y] = Cell(character: char, style: Style(fg: .green))
        }
    }
}
```

### Custom Backends

Conform to `TerminalBackend` for alternative output targets (testing, logging, etc.):

```swift
class MockTerminalBackend: TerminalBackend {
    var size: Size { Size(width: 80, height: 24) }
    func draw(_ buffer: Buffer) { /* capture for assertions */ }
    // ... other protocol requirements
}
```

## Key Handling

The `Key` enum covers standard terminal input:

| Key | Enum case |
|-----|-----------|
| Characters | `.char("a")` |
| Enter | `.enter` |
| Escape | `.escape` |
| Arrow keys | `.up`, `.down`, `.left`, `.right` |
| Tab | `.tab` |
| Backspace | `.backspace` |
| Delete | `.delete` |
| Page Up/Down | `.pageUp`, `.pageDown` |
| Home/End | `.home`, `.end` |
| F-keys | `.f(1)` ... `.f(4)` |
| Ctrl+C | `.ctrlC` |

## Testing

Tint uses [PickleKit](https://github.com/alleato-llc/pickle-kit) (a Swift-native Cucumber/BDD framework) to test widgets through buffer output assertions. Feature files live at the project root in `Features/`:

```gherkin
# Features/block_widget.feature
Scenario: Child renders inside block
  Given a buffer of width 10 and height 3
  When I render a Block with plain border containing text "Hi"
  Then cell (1, 1) should contain "H"
  And cell (2, 1) should contain "i"
```

Widgets are pure functions `(Rect, inout Buffer) -> Void`, so asserting on buffer content IS behavioral testing — no terminal session needed.

```bash
swift test                        # run all tests
swift test --filter TintBDDTests  # run only BDD scenarios
PICKLE_REPORT=1 swift test        # generate HTML report at pickle-report.html
```

See [docs/testing/BDD.md](docs/testing/BDD.md) for the full testing guide and [docs/testing/PHILOSOPHY.md](docs/testing/PHILOSOPHY.md) for design decisions.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Built with Tint

- **[aux](https://github.com/alleato-llc/aux)** — Terminal music player with library browser, real-time waveform/spectrum visualizers, and multi-format playback via LibAVKit

## License

MIT
