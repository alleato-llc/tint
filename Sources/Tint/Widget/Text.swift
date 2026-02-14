public enum TextAlignment: Sendable {
    case left
    case center
    case right
}

public struct StyledSpan: Sendable {
    public let text: String
    public let style: Style

    public init(_ text: String, style: Style = .default) {
        self.text = text
        self.style = style
    }
}

public struct TextLine: Sendable {
    public let spans: [StyledSpan]

    public init(_ spans: [StyledSpan]) {
        self.spans = spans
    }

    public init(_ text: String, style: Style = .default) {
        self.spans = [StyledSpan(text, style: style)]
    }

    public var width: Int {
        spans.reduce(0) { $0 + $1.text.count }
    }
}

public struct Text: Widget, Sendable {
    public let lines: [TextLine]
    public var alignment: TextAlignment
    public var style: Style

    public init(_ text: String, style: Style = .default, alignment: TextAlignment = .left) {
        self.lines = text.split(separator: "\n", omittingEmptySubsequences: false)
            .map { TextLine(String($0), style: style) }
        self.alignment = alignment
        self.style = style
    }

    public init(lines: [TextLine], style: Style = .default, alignment: TextAlignment = .left) {
        self.lines = lines
        self.style = style
        self.alignment = alignment
    }

    public func render(area: Rect, buffer: inout Buffer) {
        guard !area.isEmpty else { return }
        for (i, line) in lines.enumerated() {
            let y = area.y + i
            guard y < area.bottom else { break }

            let lineWidth = line.width
            let xOffset: Int
            switch alignment {
            case .left: xOffset = 0
            case .center: xOffset = max(0, (area.width - lineWidth) / 2)
            case .right: xOffset = max(0, area.width - lineWidth)
            }

            var x = area.x + xOffset
            for span in line.spans {
                let mergedStyle = style.merging(span.style)
                for char in span.text {
                    guard x < area.right else { break }
                    buffer[x, y] = Cell(character: char, style: mergedStyle)
                    x += 1
                }
            }
        }
    }
}
