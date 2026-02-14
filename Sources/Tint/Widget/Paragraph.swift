/// Word-wrapped text block.
public struct Paragraph: Widget, Sendable {
    public let text: String
    public var style: Style
    public var alignment: TextAlignment

    public init(_ text: String, style: Style = .default, alignment: TextAlignment = .left) {
        self.text = text
        self.style = style
        self.alignment = alignment
    }

    public func render(area: Rect, buffer: inout Buffer) {
        guard !area.isEmpty else { return }

        let wrapped = wordWrap(text, width: area.width)
        for (i, line) in wrapped.enumerated() {
            let y = area.y + i
            guard y < area.bottom else { break }

            let xOffset: Int
            switch alignment {
            case .left: xOffset = 0
            case .center: xOffset = max(0, (area.width - line.count) / 2)
            case .right: xOffset = max(0, area.width - line.count)
            }

            buffer.write(line, x: area.x + xOffset, y: y, style: style)
        }
    }

    private func wordWrap(_ text: String, width: Int) -> [String] {
        guard width > 0 else { return [] }
        var result: [String] = []
        let paragraphs = text.split(separator: "\n", omittingEmptySubsequences: false)

        for paragraph in paragraphs {
            let words = paragraph.split(separator: " ", omittingEmptySubsequences: false).map(String.init)
            var currentLine = ""

            for word in words {
                if currentLine.isEmpty {
                    if word.count > width {
                        // Break long word
                        var remaining = word
                        while remaining.count > width {
                            let prefix = String(remaining.prefix(width))
                            result.append(prefix)
                            remaining = String(remaining.dropFirst(width))
                        }
                        currentLine = remaining
                    } else {
                        currentLine = word
                    }
                } else if currentLine.count + 1 + word.count <= width {
                    currentLine += " " + word
                } else {
                    result.append(currentLine)
                    currentLine = word
                }
            }
            result.append(currentLine)
        }

        return result
    }
}
