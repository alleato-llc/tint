/// Renders a widget only if condition is true.
public struct ConditionalWidget: Widget {
    private let condition: Bool
    private let widget: any Widget

    public init(_ condition: Bool, @WidgetBuilder widget: () -> any Widget) {
        self.condition = condition
        self.widget = widget()
    }

    public func render(area: Rect, buffer: inout Buffer) {
        guard condition else { return }
        widget.render(area: area, buffer: &buffer)
    }
}

/// Stacks multiple widgets vertically, each getting one row.
public struct WidgetStack: Widget {
    private let widgets: [any Widget]

    public init(_ widgets: [any Widget]) {
        self.widgets = widgets
    }

    public func render(area: Rect, buffer: inout Buffer) {
        for (i, widget) in widgets.enumerated() {
            let y = area.y + i
            guard y < area.bottom else { break }
            let rowArea = Rect(x: area.x, y: y, width: area.width, height: 1)
            widget.render(area: rowArea, buffer: &buffer)
        }
    }
}

/// Overlay one widget on top of another.
public struct Overlay: Widget {
    private let background: any Widget
    private let foreground: any Widget

    public init(background: any Widget, foreground: any Widget) {
        self.background = background
        self.foreground = foreground
    }

    public func render(area: Rect, buffer: inout Buffer) {
        background.render(area: area, buffer: &buffer)
        foreground.render(area: area, buffer: &buffer)
    }
}

/// Simple result builder for widget composition.
@resultBuilder
public struct WidgetBuilder {
    public static func buildBlock(_ widget: any Widget) -> any Widget {
        widget
    }
}
