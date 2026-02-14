/// Border styles for Block widget.
public enum BorderStyle: Sendable {
    case plain
    case rounded
    case double
    case thick

    public var topLeft: Character {
        switch self {
        case .plain: return "┌"
        case .rounded: return "╭"
        case .double: return "╔"
        case .thick: return "┏"
        }
    }

    public var topRight: Character {
        switch self {
        case .plain: return "┐"
        case .rounded: return "╮"
        case .double: return "╗"
        case .thick: return "┓"
        }
    }

    public var bottomLeft: Character {
        switch self {
        case .plain: return "└"
        case .rounded: return "╰"
        case .double: return "╚"
        case .thick: return "┗"
        }
    }

    public var bottomRight: Character {
        switch self {
        case .plain: return "┘"
        case .rounded: return "╯"
        case .double: return "╝"
        case .thick: return "┛"
        }
    }

    public var horizontal: Character {
        switch self {
        case .plain, .rounded: return "─"
        case .double: return "═"
        case .thick: return "━"
        }
    }

    public var vertical: Character {
        switch self {
        case .plain, .rounded: return "│"
        case .double: return "║"
        case .thick: return "┃"
        }
    }
}

/// A border wrapper with optional title. Renders a border and then renders its child inside.
public struct Block: Widget {
    public var title: String?
    public var titleStyle: Style
    public var borderStyle: BorderStyle
    public var style: Style
    public var child: (any Widget)?

    public init(
        title: String? = nil,
        titleStyle: Style = Style(bold: true),
        borderStyle: BorderStyle = .plain,
        style: Style = .default
    ) {
        self.title = title
        self.titleStyle = titleStyle
        self.borderStyle = borderStyle
        self.style = style
        self.child = nil
    }

    /// Returns a new Block with the given child widget.
    public func containing(_ widget: any Widget) -> Block {
        var copy = self
        copy.child = widget
        return copy
    }

    public func render(area: Rect, buffer: inout Buffer) {
        guard !area.isEmpty else { return }

        let bs = borderStyle

        // Top border
        buffer[area.x, area.y] = Cell(character: bs.topLeft, style: style)
        buffer[area.right - 1, area.y] = Cell(character: bs.topRight, style: style)
        for x in (area.x + 1)..<(area.right - 1) {
            buffer[x, area.y] = Cell(character: bs.horizontal, style: style)
        }

        // Title
        if let title, !title.isEmpty, area.width > 4 {
            let titleText = " \(title) "
            let maxLen = area.width - 4
            let truncated = String(titleText.prefix(maxLen))
            buffer.write(truncated, x: area.x + 2, y: area.y, style: titleStyle)
        }

        // Bottom border
        if area.height > 1 {
            buffer[area.x, area.bottom - 1] = Cell(character: bs.bottomLeft, style: style)
            buffer[area.right - 1, area.bottom - 1] = Cell(character: bs.bottomRight, style: style)
            for x in (area.x + 1)..<(area.right - 1) {
                buffer[x, area.bottom - 1] = Cell(character: bs.horizontal, style: style)
            }
        }

        // Side borders
        for y in (area.y + 1)..<(area.bottom - 1) {
            buffer[area.x, y] = Cell(character: bs.vertical, style: style)
            buffer[area.right - 1, y] = Cell(character: bs.vertical, style: style)
        }

        // Render child in inner area
        if let child {
            let innerArea = area.inner
            if !innerArea.isEmpty {
                child.render(area: innerArea, buffer: &buffer)
            }
        }
    }
}
