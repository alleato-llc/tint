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
    public var horizontalOffset: Int

    public init(
        items: [Item],
        selected: Int? = nil,
        highlightStyle: Style = Style(fg: .black, bg: .white, bold: true),
        highlightSymbol: String = "> ",
        horizontalOffset: Int = 0
    ) {
        self.items = items
        self.selected = selected
        self.highlightStyle = highlightStyle
        self.highlightSymbol = highlightSymbol
        self.horizontalOffset = horizontalOffset
    }

    public func render(area: Rect, buffer: inout Buffer) {
        guard !area.isEmpty, !items.isEmpty else { return }

        let visibleCount = area.height
        let offset = scrollOffset(selected: selected ?? 0, total: items.count, visible: visibleCount)
        let symbolWidth = highlightSymbol.count
        let textWidth = area.width - symbolWidth

        for i in 0..<visibleCount {
            let itemIndex = offset + i
            guard itemIndex < items.count else { break }
            let y = area.y + i
            let item = items[itemIndex]
            let isSelected = itemIndex == selected

            let visibleText = applyHorizontalOffset(item.text, offset: horizontalOffset, width: textWidth)

            if isSelected {
                buffer.fill(
                    Rect(x: area.x, y: y, width: area.width, height: 1),
                    cell: Cell(character: " ", style: highlightStyle)
                )
                buffer.write(highlightSymbol, x: area.x, y: y, style: highlightStyle)
                buffer.write(visibleText, x: area.x + symbolWidth, y: y, style: highlightStyle)
            } else {
                let padding = String(repeating: " ", count: symbolWidth)
                buffer.write(padding + visibleText, x: area.x, y: y, style: item.style)
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

    private func applyHorizontalOffset(_ text: String, offset: Int, width: Int) -> String {
        guard width > 0 else { return "" }
        let shifted = offset > 0 ? String(text.dropFirst(min(offset, text.count))) : text
        return String(shifted.prefix(width))
    }
}
