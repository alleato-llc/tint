/// A labeled progress bar combining a label, progress bar, and percentage.
public struct Gauge: Widget, Sendable {
    public var label: String
    public var progress: Double
    public var labelStyle: Style
    public var barStyle: Style
    public var percentStyle: Style

    public init(
        label: String = "",
        progress: Double = 0.0,
        labelStyle: Style = .default,
        barStyle: Style = Style(fg: .cyan),
        percentStyle: Style = Style(fg: .brightBlack)
    ) {
        self.label = label
        self.progress = min(1.0, max(0.0, progress))
        self.labelStyle = labelStyle
        self.barStyle = barStyle
        self.percentStyle = percentStyle
    }

    public func render(area: Rect, buffer: inout Buffer) {
        guard !area.isEmpty else { return }

        let percentText = String(format: " %3.0f%%", progress * 100)
        let labelWidth = label.isEmpty ? 0 : label.count + 1

        // Label | [====    ] | 50%
        let percentWidth = percentText.count
        let barWidth = max(0, area.width - labelWidth - percentWidth)

        if !label.isEmpty {
            let truncLabel = String(label.prefix(area.width))
            buffer.write(truncLabel, x: area.x, y: area.y, style: labelStyle)
        }

        if barWidth > 0 {
            let barArea = Rect(x: area.x + labelWidth, y: area.y, width: barWidth, height: 1)
            let bar = ProgressBar(
                progress: progress,
                filledStyle: barStyle,
                showBrackets: true
            )
            bar.render(area: barArea, buffer: &buffer)
        }

        let pctX = area.x + labelWidth + barWidth
        if pctX < area.right {
            buffer.write(percentText, x: pctX, y: area.y, style: percentStyle)
        }
    }
}
