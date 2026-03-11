# Tint Widget Reference

## Text

Single or multi-line text with alignment and styled spans.

```swift
// Simple
Text("Hello", style: Style(fg: .cyan), alignment: .center)

// Styled spans
Text(lines: [
    TextLine([
        StyledSpan("Error: ", style: Style(fg: .red, bold: true)),
        StyledSpan("file not found", style: Style(fg: .white))
    ])
], alignment: .left)
```

**TextAlignment**: `.left`, `.center`, `.right`
Truncates text that exceeds area width.

## Paragraph

Word-wrapped text. Same interface as Text but wraps at word boundaries.

```swift
Paragraph("Long text that will wrap at word boundaries", style: Style(fg: .white))
```

## Block

Border wrapper with optional title. Use `.containing(_:)` to set a child widget.

```swift
Block(title: "Status", borderStyle: .rounded, style: Style(fg: .cyan))
    .containing(Text("All systems go", style: Style(fg: .green)))
```

**BorderStyle**: `.plain` (`+-+`), `.rounded` (curved corners), `.double` (`=`), `.thick` (heavy lines)

Block renders borders in its area and passes the inner rect (`area.inset(top:right:bottom:left:)`) to the child.

## ListWidget

Scrollable list with selection highlighting. Auto-scrolls to keep selection visible.

```swift
ListWidget(
    items: [
        ListWidget.Item("First", style: Style(fg: .white)),
        ListWidget.Item("Second"),
        ListWidget.Item("Third")
    ],
    selected: 0,
    highlightStyle: Style(fg: .black, bg: .cyan, bold: true),
    highlightSymbol: "> "
)
```

## Table

Columnar data with header row, separator, and selection.

```swift
Table(
    columns: [
        Table.Column("Name", width: .fixed(15)),
        Table.Column("Status", width: .fill)
    ],
    rows: [
        Table.Row(["Server A", "Online"], style: Style(fg: .green)),
        Table.Row(["Server B", "Offline"], style: Style(fg: .red))
    ],
    selected: 0,
    columnSpacing: 2
)
```

Column widths use the same `Constraint` enum as Layout.

## ProgressBar

```swift
ProgressBar(
    progress: 0.65,           // 0.0-1.0, auto-clamped
    filledChar: "\u{2588}",   // default: block
    emptyChar: "\u{2591}",    // default: light shade
    filledStyle: Style(fg: .cyan),
    emptyStyle: Style(fg: .brightBlack),
    showBrackets: true        // renders [ ] around bar
)
```

## Gauge

Label + progress bar + percentage display.

```swift
Gauge(
    label: "Upload",
    progress: 0.42,
    labelStyle: Style(fg: .white),
    barStyle: Style(fg: .green),
    percentStyle: Style(fg: .brightBlack)
)
// Renders: "Upload [████░░░░░░] 42%"
```

## Composite Widgets

```swift
// Conditional rendering
ConditionalWidget(showError) {
    Text("Error occurred!", style: Style(fg: .red))
}

// Vertical stack (one widget per row)
WidgetStack([widget1, widget2, widget3])

// Layer foreground on background
Overlay(background: backgroundWidget, foreground: popupWidget)
```

## Rendering pattern

All widgets follow the same pattern:

```swift
let area = Rect(x: 0, y: 0, width: 40, height: 10)
var buffer = Buffer(area: area)
widget.render(area: area, buffer: &buffer)
```

Widgets write to the buffer and never produce side effects.
