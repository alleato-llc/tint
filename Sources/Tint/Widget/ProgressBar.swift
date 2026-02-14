/// A horizontal progress bar.
public struct ProgressBar: Widget, Sendable {
    public var progress: Double
    public var filledChar: Character
    public var emptyChar: Character
    public var filledStyle: Style
    public var emptyStyle: Style
    public var showBrackets: Bool

    public init(
        progress: Double,
        filledChar: Character = "█",
        emptyChar: Character = "░",
        filledStyle: Style = Style(fg: .cyan),
        emptyStyle: Style = Style(fg: .brightBlack),
        showBrackets: Bool = true
    ) {
        self.progress = min(1.0, max(0.0, progress))
        self.filledChar = filledChar
        self.emptyChar = emptyChar
        self.filledStyle = filledStyle
        self.emptyStyle = emptyStyle
        self.showBrackets = showBrackets
    }

    public func render(area: Rect, buffer: inout Buffer) {
        guard !area.isEmpty, area.width > 0 else { return }

        let y = area.y
        var barWidth = area.width
        var startX = area.x

        if showBrackets && barWidth >= 2 {
            buffer[area.x, y] = Cell(character: "[", style: emptyStyle)
            buffer[area.right - 1, y] = Cell(character: "]", style: emptyStyle)
            startX += 1
            barWidth -= 2
        }

        guard barWidth > 0 else { return }

        let filledCount = Int(Double(barWidth) * progress)
        for i in 0..<barWidth {
            let x = startX + i
            if i < filledCount {
                buffer[x, y] = Cell(character: filledChar, style: filledStyle)
            } else {
                buffer[x, y] = Cell(character: emptyChar, style: emptyStyle)
            }
        }
    }
}
