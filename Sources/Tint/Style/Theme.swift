public protocol Theme: Sendable {
    var primary: Style { get }
    var secondary: Style { get }
    var highlight: Style { get }
    var accent: Style { get }
    var muted: Style { get }
    var border: Style { get }
    var title: Style { get }
    var error: Style { get }
    var statusBar: Style { get }
}

public struct DefaultTheme: Theme, Sendable {
    public init() {}

    public var primary: Style { Style(fg: .white) }
    public var secondary: Style { Style(fg: .brightBlack) }
    public var highlight: Style { Style(fg: .black, bg: .white, bold: true) }
    public var accent: Style { Style(fg: .cyan, bold: true) }
    public var muted: Style { Style(fg: .brightBlack, dim: true) }
    public var border: Style { Style(fg: .brightBlack) }
    public var title: Style { Style(fg: .white, bold: true) }
    public var error: Style { Style(fg: .red, bold: true) }
    public var statusBar: Style { Style(fg: .white, bg: .brightBlack) }
}
