#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif

public final class ANSITerminal: TerminalBackend, @unchecked Sendable {
    private var originalTermios: termios?
    private var previousBuffer: Buffer?
    private var lastSize: Size?

    public init() {}

    public var size: Size {
        var ws = winsize()
        if ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws) == 0 {
            return Size(width: Int(ws.ws_col), height: Int(ws.ws_row))
        }
        return Size(width: 80, height: 24)
    }

    public func enableRawMode() {
        var raw = termios()
        tcgetattr(STDIN_FILENO, &raw)
        originalTermios = raw
        raw.c_lflag &= ~tcflag_t(ECHO | ICANON | ISIG | IEXTEN)
        raw.c_iflag &= ~tcflag_t(IXON | ICRNL | BRKINT | INPCK | ISTRIP)
        raw.c_oflag &= ~tcflag_t(OPOST)
        raw.c_cc.6 = 1   // VMIN
        raw.c_cc.5 = 0   // VTIME
        tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw)
    }

    public func disableRawMode() {
        if var original = originalTermios {
            tcsetattr(STDIN_FILENO, TCSAFLUSH, &original)
            originalTermios = nil
        }
    }

    public func enterAlternateScreen() {
        writeOutput("\u{1b}[?1049h")
    }

    public func exitAlternateScreen() {
        writeOutput("\u{1b}[?1049l")
    }

    public func hideCursor() {
        writeOutput("\u{1b}[?25l")
    }

    public func showCursor() {
        writeOutput("\u{1b}[?25h")
    }

    public func draw(_ buffer: Buffer) {
        var output = ""
        var lastStyle: Style? = nil

        let currentSize = Size(width: buffer.area.width, height: buffer.area.height)
        if lastSize != currentSize {
            // Terminal resized — clear screen and discard stale buffer
            output += "\u{1b}[2J"
            previousBuffer = nil
            lastSize = currentSize
        }

        for row in 0..<buffer.area.height {
            let y = buffer.area.y + row
            // Move cursor to start of this row
            output += "\u{1b}[\(y + 1);1H"

            for col in 0..<buffer.area.width {
                let x = buffer.area.x + col
                let cell = buffer[x, y]

                // Check if we can skip this cell (matches previous buffer)
                if let prev = previousBuffer, prev[x, y] == cell {
                    continue
                }

                // Position cursor if we skipped cells
                output += "\u{1b}[\(y + 1);\(x + 1)H"

                if cell.style != lastStyle {
                    output += cell.style.ansiSequence
                    lastStyle = cell.style
                }
                output.append(cell.character)
            }
        }

        // Reset style at end
        output += "\u{1b}[0m"
        writeOutput(output)
        previousBuffer = buffer
    }

    public func flush() {
        fflush(stdout)
    }

    private func writeOutput(_ str: String) {
        str.withCString { ptr in
            _ = Darwin.write(STDOUT_FILENO, ptr, strlen(ptr))
        }
    }
}
