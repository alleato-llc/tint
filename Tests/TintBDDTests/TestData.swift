import Tint

enum TestData {
    static func area(width: Int, height: Int) -> Rect {
        Rect(x: 0, y: 0, width: width, height: height)
    }

    static func buffer(width: Int, height: Int) -> Buffer {
        Buffer(area: area(width: width, height: height))
    }

    static func color(named name: String) -> Color? {
        switch name.lowercased() {
        case "default": return .default
        case "black": return .black
        case "red": return .red
        case "green": return .green
        case "yellow": return .yellow
        case "blue": return .blue
        case "magenta": return .magenta
        case "cyan": return .cyan
        case "white": return .white
        case "brightblack", "bright black": return .brightBlack
        case "brightred", "bright red": return .brightRed
        case "brightgreen", "bright green": return .brightGreen
        case "brightyellow", "bright yellow": return .brightYellow
        case "brightblue", "bright blue": return .brightBlue
        case "brightmagenta", "bright magenta": return .brightMagenta
        case "brightcyan", "bright cyan": return .brightCyan
        case "brightwhite", "bright white": return .brightWhite
        default: return nil
        }
    }

    static func borderStyle(named name: String) -> BorderStyle? {
        switch name.lowercased() {
        case "plain": return .plain
        case "rounded": return .rounded
        case "double": return .double
        case "thick": return .thick
        default: return nil
        }
    }
}
