/// Columnar data with headers and row selection.
public struct Table: Widget, Sendable {
    public struct Column: Sendable {
        public let header: String
        public let width: Constraint

        public init(_ header: String, width: Constraint = .fill) {
            self.header = header
            self.width = width
        }
    }

    public struct Row: Sendable {
        public let cells: [String]
        public let style: Style

        public init(_ cells: [String], style: Style = .default) {
            self.cells = cells
            self.style = style
        }
    }

    public let columns: [Column]
    public let rows: [Row]
    public var selected: Int?
    public var headerStyle: Style
    public var highlightStyle: Style
    public var columnSpacing: Int

    public init(
        columns: [Column],
        rows: [Row],
        selected: Int? = nil,
        headerStyle: Style = Style(bold: true),
        highlightStyle: Style = Style(fg: .black, bg: .white, bold: true),
        columnSpacing: Int = 1
    ) {
        self.columns = columns
        self.rows = rows
        self.selected = selected
        self.headerStyle = headerStyle
        self.highlightStyle = highlightStyle
        self.columnSpacing = columnSpacing
    }

    public func render(area: Rect, buffer: inout Buffer) {
        guard !area.isEmpty, !columns.isEmpty else { return }

        let colWidths = resolveColumnWidths(totalWidth: area.width)

        // Render header
        renderRow(
            cells: columns.map(\.header),
            widths: colWidths,
            y: area.y,
            area: area,
            style: headerStyle,
            buffer: &buffer
        )

        // Separator
        if area.height > 1 {
            let sep = String(repeating: "─", count: area.width)
            buffer.write(sep, x: area.x, y: area.y + 1, style: headerStyle)
        }

        // Rows
        let startRow = area.y + 2
        let visibleCount = area.height - 2
        let offset = scrollOffset(selected: selected ?? 0, total: rows.count, visible: visibleCount)

        for i in 0..<visibleCount {
            let rowIndex = offset + i
            guard rowIndex < rows.count else { break }
            let y = startRow + i
            let row = rows[rowIndex]
            let isSelected = rowIndex == selected

            if isSelected {
                buffer.fill(
                    Rect(x: area.x, y: y, width: area.width, height: 1),
                    cell: Cell(character: " ", style: highlightStyle)
                )
            }

            renderRow(
                cells: row.cells,
                widths: colWidths,
                y: y,
                area: area,
                style: isSelected ? highlightStyle : row.style,
                buffer: &buffer
            )
        }
    }

    private func renderRow(
        cells: [String], widths: [Int], y: Int,
        area: Rect, style: Style, buffer: inout Buffer
    ) {
        var x = area.x
        for (col, width) in widths.enumerated() {
            guard col < cells.count else { break }
            let text = String(cells[col].prefix(width))
            buffer.write(text, x: x, y: y, style: style)
            x += width + columnSpacing
        }
    }

    private func resolveColumnWidths(totalWidth: Int) -> [Int] {
        let spacing = max(0, (columns.count - 1) * columnSpacing)
        let available = max(0, totalWidth - spacing)

        var widths = Array(repeating: 0, count: columns.count)
        var remaining = available
        var fillCount = 0

        // First pass: fixed and percentage
        for (i, col) in columns.enumerated() {
            switch col.width {
            case .fixed(let w):
                widths[i] = min(w, remaining)
                remaining -= widths[i]
            case .percentage(let pct):
                widths[i] = min(available * pct / 100, remaining)
                remaining -= widths[i]
            case .min(let m):
                widths[i] = min(m, remaining)
                remaining -= widths[i]
            case .max(let m):
                widths[i] = min(m, remaining)
                remaining -= widths[i]
                fillCount += 1
            case .fill:
                fillCount += 1
            }
        }

        // Second pass: distribute remaining to fill columns
        if fillCount > 0 && remaining > 0 {
            let perFill = remaining / fillCount
            var extra = remaining % fillCount
            for (i, col) in columns.enumerated() {
                if case .fill = col.width {
                    widths[i] = perFill + (extra > 0 ? 1 : 0)
                    if extra > 0 { extra -= 1 }
                } else if case .max = col.width {
                    widths[i] += perFill + (extra > 0 ? 1 : 0)
                    if extra > 0 { extra -= 1 }
                }
            }
        }

        return widths
    }

    private func scrollOffset(selected: Int, total: Int, visible: Int) -> Int {
        guard visible > 0, visible < total else { return 0 }
        let halfVisible = visible / 2
        if selected <= halfVisible {
            return 0
        } else if selected >= total - halfVisible {
            return total - visible
        } else {
            return selected - halfVisible
        }
    }
}
