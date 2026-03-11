---
name: building-tui-apps
description: Build terminal user interface applications with the Tint Swift framework. Covers widget rendering, layout splitting, styling, key input handling, and the application loop. Use when the user wants to create a TUI app, add widgets, handle keyboard input, or work with terminal rendering in Swift using Tint.
---

# Building TUI Apps with Tint

Tint is a Swift TUI framework. Widgets are pure functions `(Rect, inout Buffer) -> Void` — stateless renderers composed via layouts.

## Quick start

Add Tint to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/alleato-llc/tint.git", from: "0.1.0")
]
```

Minimal app:

```swift
import Tint

let app = Application()
var count = 0

app.run(
    render: { area, buffer in
        Text("Count: \(count)").render(area: area, buffer: &buffer)
    },
    onKey: { key in
        switch key {
        case .char("q"), .ctrlC: app.quit()
        case .char(" "): count += 1
        default: break
        }
    }
)
```

## Core concepts

**Buffer**: 2D grid of styled `Cell`s. All rendering writes to a buffer.
**Rect**: Positioned rectangle `(x, y, width, height)` defining render areas.
**Widget protocol**: `func render(area: Rect, buffer: inout Buffer)` — every widget conforms to this.
**Layout**: Splits a `Rect` into sub-rects using constraints (`.fixed`, `.percentage`, `.min`, `.max`, `.fill`).
**Style**: Foreground/background color + bold/italic/underline/dim/reversed attributes.
**Application**: Main loop — sets up terminal, runs render/key callbacks, handles cleanup.

## Available widgets

| Widget | Purpose |
|--------|---------|
| `Text` | Single/multi-line text with alignment and styled spans |
| `Paragraph` | Word-wrapped text |
| `Block` | Border wrapper with optional title + child widget |
| `ListWidget` | Scrollable list with selection highlighting |
| `Table` | Columnar data with headers and selection |
| `ProgressBar` | Horizontal progress indicator |
| `Gauge` | Label + progress bar + percentage |
| `ConditionalWidget` | Renders child only when condition is true |
| `WidgetStack` | Stacks widgets vertically (one row each) |
| `Overlay` | Renders foreground on top of background |

For complete widget API: See [WIDGETS.md](WIDGETS.md)
For layout system details: See [LAYOUTS.md](LAYOUTS.md)
For colors, styles, themes: See [STYLES.md](STYLES.md)
For full examples: See [EXAMPLES.md](EXAMPLES.md)

## Key input

`Key` enum values: `.char(Character)`, `.enter`, `.escape`, `.tab`, `.backspace`, `.delete`, `.up`, `.down`, `.left`, `.right`, `.home`, `.end`, `.pageUp`, `.pageDown`, `.f(Int)`, `.scrollUp`, `.scrollDown`, `.ctrlC`

## Application lifecycle

1. `Application(backend:theme:)` — defaults to `ANSITerminal()` + `DefaultTheme()`
2. `app.run(render:onKey:)` — blocking; render called ~100ms + after key events
3. `app.quit()` — restores terminal and exits

For testing, pass a `MockTerminalBackend` instead of `ANSITerminal`.

## Custom widgets

```swift
struct MyWidget: Widget {
    let label: String

    func render(area: Rect, buffer: inout Buffer) {
        buffer.write(label, x: area.x, y: area.y, style: Style(fg: .green, bold: true))
    }
}
```

## Platform requirements

- Swift 6.2+, macOS 14+
- All core types are `Sendable`
