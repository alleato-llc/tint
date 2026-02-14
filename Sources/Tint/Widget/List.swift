/// A scrollable list widget with selection highlight.
public struct ListWidget: Widget, Sendable {
    public struct Item: Sendable {
        public let text: String
        public let style: Style

        public init(_ text: String, style: Style = .default) {
            self.text = text
            self.style = style
        }
    }

    public let items: [Item]
    public var selected: Int?
    public var highlightStyle: Style
    public var highlightSymbol: String

    public init(
        items: [Item],
        selected: Int? = nil,
        highlightStyle: Style = Style(fg: .black, bg: .white, bold: true),
        highlightSymbol: String = "> "
    ) {
        self.items = items
        self.selected = selected
        self.highlightStyle = highlightStyle
        self.highlightSymbol = highlightSymbol
    }

    public func render(area: Rect, buffer: inout Buffer) {
        guard !area.isEmpty, !items.isEmpty else { return }

        let visibleCount = area.height
        let offset = scrollOffset(selected: selected ?? 0, total: items.count, visible: visibleCount)

        for i in 0..<visibleCount {
            let itemIndex = offset + i
            guard itemIndex < items.count else { break }
            let y = area.y + i
            let item = items[itemIndex]
            let isSelected = itemIndex == selected

            if isSelected {
                // Fill line with highlight style
                buffer.fill(
                    Rect(x: area.x, y: y, width: area.width, height: 1),
                    cell: Cell(character: " ", style: highlightStyle)
                )
                buffer.write(highlightSymbol, x: area.x, y: y, style: highlightStyle)
                let text = truncate(item.text, to: area.width - highlightSymbol.count)
                buffer.write(text, x: area.x + highlightSymbol.count, y: y, style: highlightStyle)
            } else {
                let padding = String(repeating: " ", count: highlightSymbol.count)
                let text = truncate(item.text, to: area.width - highlightSymbol.count)
                buffer.write(padding + text, x: area.x, y: y, style: item.style)
            }
        }
    }

    private func scrollOffset(selected: Int, total: Int, visible: Int) -> Int {
        guard visible < total else { return 0 }
        let halfVisible = visible / 2
        if selected <= halfVisible {
            return 0
        } else if selected >= total - halfVisible {
            return total - visible
        } else {
            return selected - halfVisible
        }
    }

    private func truncate(_ text: String, to maxWidth: Int) -> String {
        guard text.count > maxWidth, maxWidth > 3 else {
            return String(text.prefix(max(0, maxWidth)))
        }
        return String(text.prefix(maxWidth - 3)) + "..."
    }
}
