# Tint Examples

## Dashboard app

```swift
import Tint

let app = Application()
var selectedTab = 0
let tabs = ["Overview", "Logs", "Settings"]

app.run(
    render: { area, buffer in
        let main = Layout(direction: .vertical, constraints: [
            .fixed(3), .fill, .fixed(1)
        ]).split(area)

        // Header with tabs
        Block(title: "Dashboard", borderStyle: .rounded)
            .containing(Text(
                tabs.enumerated().map { i, t in
                    i == selectedTab ? "[\(t)]" : " \(t) "
                }.joined(),
                style: Style(fg: .cyan)
            ))
            .render(area: main[0], buffer: &buffer)

        // Content area with sidebar
        let content = Layout(direction: .horizontal, constraints: [
            .fixed(20), .fill
        ]).split(main[1])

        ListWidget(
            items: ["CPU", "Memory", "Disk", "Network"].map { ListWidget.Item($0) },
            selected: 0,
            highlightStyle: Style(fg: .black, bg: .cyan, bold: true)
        ).render(area: content[0], buffer: &buffer)

        Block(title: "Details", borderStyle: .plain)
            .containing(Paragraph("System metrics and details go here."))
            .render(area: content[1], buffer: &buffer)

        // Status bar
        Text(" Q: Quit | Tab: Switch | \u{2191}\u{2193}: Navigate ",
             style: Style(fg: .white, bg: .brightBlack))
            .render(area: main[2], buffer: &buffer)
    },
    onKey: { key in
        switch key {
        case .char("q"), .ctrlC: app.quit()
        case .tab: selectedTab = (selectedTab + 1) % tabs.count
        default: break
        }
    }
)
```

## Progress tracking

```swift
import Tint

let app = Application()
var progress = 0.0

app.run(
    render: { area, buffer in
        let rows = Layout(direction: .vertical, constraints: [
            .fixed(3), .fixed(1), .fixed(1), .fill
        ]).split(area)

        Block(title: "Download", borderStyle: .rounded)
            .containing(ProgressBar(progress: progress, filledStyle: Style(fg: .green)))
            .render(area: rows[0], buffer: &buffer)

        Gauge(label: "Overall", progress: progress, barStyle: Style(fg: .cyan))
            .render(area: rows[2], buffer: &buffer)
    },
    onKey: { key in
        switch key {
        case .char("q"), .ctrlC: app.quit()
        case .right: progress = min(1.0, progress + 0.1)
        case .left: progress = max(0.0, progress - 0.1)
        default: break
        }
    }
)
```

## Table viewer

```swift
import Tint

let app = Application()
var selectedRow = 0
let rows = [
    Table.Row(["Alice", "Engineering", "Active"]),
    Table.Row(["Bob", "Design", "Away"], style: Style(fg: .yellow)),
    Table.Row(["Carol", "Product", "Active"]),
]

app.run(
    render: { area, buffer in
        Block(title: "Team", borderStyle: .double)
            .containing(Table(
                columns: [
                    Table.Column("Name", width: .fixed(15)),
                    Table.Column("Dept", width: .fixed(15)),
                    Table.Column("Status", width: .fill)
                ],
                rows: rows,
                selected: selectedRow
            ))
            .render(area: area, buffer: &buffer)
    },
    onKey: { key in
        switch key {
        case .char("q"), .ctrlC: app.quit()
        case .up: selectedRow = max(0, selectedRow - 1)
        case .down: selectedRow = min(rows.count - 1, selectedRow + 1)
        default: break
        }
    }
)
```

## Custom widget

```swift
struct StatusIndicator: Widget {
    let online: Bool

    func render(area: Rect, buffer: inout Buffer) {
        let symbol = online ? "\u{25CF}" : "\u{25CB}"
        let style = Style(fg: online ? .green : .red, bold: true)
        buffer.write("\(symbol) \(online ? "Online" : "Offline")",
                     x: area.x, y: area.y, style: style)
    }
}

// Usage in render callback:
StatusIndicator(online: true).render(area: statusArea, buffer: &buffer)
```
