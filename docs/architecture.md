# Architecture

A detailed design overview of Tint's rendering pipeline, core abstractions, and module structure.

## Rendering Model

Tint uses an **immediate-mode rendering** pipeline:

```
app.run() loop
    │
    ▼
┌─────────────────────┐
│  render(area, buf)   │  Your closure is called each frame
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│  Widget.render()     │  Widgets write styled characters into a Buffer
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│  Buffer (2D grid)    │  Grid of Cell values (character + style)
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│  Terminal diff       │  Only changed cells are written to the terminal
└─────────────────────┘
```

State lives in your code — widgets are stateless renderers. Each frame, your render closure receives the full terminal area and a fresh buffer. Widgets write into the buffer, and the framework diffs against the previous frame to minimize terminal output.

## Core Types

### Buffer

A 2D grid of `Cell` values representing the terminal screen. Widgets write into buffers; the framework reads from them.

- `write(_:x:y:style:)` — write a string at a position
- `fill(_:cell:)` — fill a rectangular region
- `merge(_:)` — overlay another buffer's non-empty cells
- `setStyle(_:style:)` — apply a style to a region
- `reset()` — clear all cells to empty

### Cell

A single terminal character with its style. `Cell.empty` is a space with the default style.

### Rect

A positioned rectangle (`x`, `y`, `width`, `height`) used for areas, clipping, and layout. Key properties: `inner` (inset by 1 on each side, used by Block for child area), `intersection(_:)`, `contains(_:)`.

### Style

Foreground color, background color, and text attributes (bold, italic, underline, dim, reversed). Styles compose via `merging(_:)` — non-default overlay values override the base.

### Color

Named colors (`.red`, `.blue`, `.brightCyan`, etc.), ANSI-256 (`.ansi256(n)`), and true color (`.rgb(r, g, b)`). `.default` means the terminal's default color.

## Layout System

`Layout` splits a `Rect` into sub-rects using constraints:

```
Layout(direction: .vertical, constraints: [.fixed(3), .fill, .fixed(1)])
    │
    ▼
┌──────────────────────────────────┐
│  Header area (3 rows)            │  .fixed(3)
├──────────────────────────────────┤
│                                  │
│  Content area (remaining rows)   │  .fill
│                                  │
├──────────────────────────────────┤
│  Footer area (1 row)             │  .fixed(1)
└──────────────────────────────────┘
```

Constraint types:
- `.fixed(n)` — exact size in the layout direction
- `.percentage(n)` — percentage of total available space
- `.min(n)` — at least n, then participates in fill distribution
- `.max(n)` — at most n, then participates in fill distribution
- `.fill` — takes remaining space, divided equally among multiple fills

## Widget Protocol

All widgets implement a single method:

```swift
protocol Widget {
    func render(area: Rect, buffer: inout Buffer)
}
```

Widgets are value types (structs) with no internal state. They read their configuration from stored properties and write directly into the buffer. This makes them trivially testable — create a buffer, render, assert on content.

### Built-in Widgets

| Widget | Purpose |
|--------|---------|
| `Text` | Single/multi-line text with alignment and styled spans |
| `Paragraph` | Word-wrapped text block |
| `Block` | Border wrapper with optional title, contains a child widget |
| `ListWidget` | Scrollable list with selection highlight |
| `Table` | Columnar data with headers, separator, and row selection |
| `ProgressBar` | Horizontal progress indicator |
| `Gauge` | Label + progress bar + percentage display |

### Composites

- `ConditionalWidget` — renders one of two widgets based on a boolean
- `WidgetStack` — renders multiple widgets in sequence
- `Overlay` — renders a widget on top of another

## Terminal Layer

### TerminalBackend Protocol

Abstracts terminal I/O for testability:

```swift
protocol TerminalBackend {
    var size: Size { get }
    func draw(_ buffer: Buffer)
    func flush()
    func enableRawMode()
    func disableRawMode()
    func enterAlternateScreen()
    func exitAlternateScreen()
    func hideCursor()
    func showCursor()
}
```

`ANSITerminal` is the production implementation (POSIX terminal + ANSI escape codes). `MockTerminalBackend` is used in tests.

### Input Handling

`InputReader` parses raw terminal bytes into `Key` values. The application loop polls for input and dispatches to your `onKey` handler. Key events include characters, arrow keys, function keys, and control sequences.

## Application Loop

`Application` ties everything together:

1. Enter alternate screen, enable raw mode, hide cursor
2. Loop: poll for key input → call `onKey` → call `render` → diff buffer → draw changes
3. On quit: restore terminal state (show cursor, disable raw mode, exit alternate screen)

The application owns the terminal backend and theme. Your code owns all state and rendering logic.

## Theming

The `Theme` protocol defines semantic style slots (primary, secondary, highlight, accent, muted, border, title, error, statusBar). `DefaultTheme` provides sensible defaults. Custom themes conform to the protocol and are passed to `Application(theme:)`.

## Module Structure

```
Sources/Tint/
├── Core/           Buffer, Cell, Rect — the rendering primitives
├── Style/          Color, Style, Theme — visual presentation
├── Layout/         Constraint, Layout — spatial subdivision
├── Widget/         Widget protocol + all built-in widgets
├── Terminal/       ANSITerminal, InputReader, Key, TerminalBackend
└── App/            Application — the main loop
```
