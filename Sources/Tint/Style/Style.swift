public struct Style: Equatable, Hashable, Sendable {
    public var fg: Color
    public var bg: Color
    public var bold: Bool
    public var italic: Bool
    public var underline: Bool
    public var dim: Bool
    public var reversed: Bool

    public init(
        fg: Color = .default,
        bg: Color = .default,
        bold: Bool = false,
        italic: Bool = false,
        underline: Bool = false,
        dim: Bool = false,
        reversed: Bool = false
    ) {
        self.fg = fg
        self.bg = bg
        self.bold = bold
        self.italic = italic
        self.underline = underline
        self.dim = dim
        self.reversed = reversed
    }

    public static let `default` = Style()

    /// Returns the ANSI SGR escape sequence for this style.
    public var ansiSequence: String {
        var codes: [String] = []
        codes.append("0") // reset first
        if bold { codes.append("1") }
        if dim { codes.append("2") }
        if italic { codes.append("3") }
        if underline { codes.append("4") }
        if reversed { codes.append("7") }
        codes.append(fg.fgCode)
        codes.append(bg.bgCode)
        return "\u{1b}[\(codes.joined(separator: ";"))m"
    }

    /// Merges another style on top, overriding non-default values.
    public func merging(_ other: Style) -> Style {
        Style(
            fg: other.fg != .default ? other.fg : fg,
            bg: other.bg != .default ? other.bg : bg,
            bold: other.bold || bold,
            italic: other.italic || italic,
            underline: other.underline || underline,
            dim: other.dim || dim,
            reversed: other.reversed || reversed
        )
    }
}
