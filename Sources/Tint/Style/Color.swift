public enum Color: Equatable, Hashable, Sendable {
    case `default`
    case black
    case red
    case green
    case yellow
    case blue
    case magenta
    case cyan
    case white
    case brightBlack
    case brightRed
    case brightGreen
    case brightYellow
    case brightBlue
    case brightMagenta
    case brightCyan
    case brightWhite
    case ansi256(UInt8)
    case rgb(UInt8, UInt8, UInt8)

    /// ANSI escape code for foreground color.
    public var fgCode: String {
        switch self {
        case .default: return "39"
        case .black: return "30"
        case .red: return "31"
        case .green: return "32"
        case .yellow: return "33"
        case .blue: return "34"
        case .magenta: return "35"
        case .cyan: return "36"
        case .white: return "37"
        case .brightBlack: return "90"
        case .brightRed: return "91"
        case .brightGreen: return "92"
        case .brightYellow: return "93"
        case .brightBlue: return "94"
        case .brightMagenta: return "95"
        case .brightCyan: return "96"
        case .brightWhite: return "97"
        case .ansi256(let n): return "38;5;\(n)"
        case .rgb(let r, let g, let b): return "38;2;\(r);\(g);\(b)"
        }
    }

    /// ANSI escape code for background color.
    public var bgCode: String {
        switch self {
        case .default: return "49"
        case .black: return "40"
        case .red: return "41"
        case .green: return "42"
        case .yellow: return "43"
        case .blue: return "44"
        case .magenta: return "45"
        case .cyan: return "46"
        case .white: return "47"
        case .brightBlack: return "100"
        case .brightRed: return "101"
        case .brightGreen: return "102"
        case .brightYellow: return "103"
        case .brightBlue: return "104"
        case .brightMagenta: return "105"
        case .brightCyan: return "106"
        case .brightWhite: return "107"
        case .ansi256(let n): return "48;5;\(n)"
        case .rgb(let r, let g, let b): return "48;2;\(r);\(g);\(b)"
        }
    }
}
