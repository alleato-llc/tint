#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif
import Foundation

/// Reads key events from stdin, parsing ANSI escape sequences.
public final class InputReader: @unchecked Sendable {
    private var dispatchSource: DispatchSourceRead?
    private let handler: @Sendable (Key) -> Void

    public init(handler: @escaping @Sendable (Key) -> Void) {
        self.handler = handler
    }

    public func start() {
        let source = DispatchSource.makeReadSource(fileDescriptor: STDIN_FILENO, queue: .main)
        source.setEventHandler { [weak self] in
            self?.readInput()
        }
        source.resume()
        dispatchSource = source
    }

    public func stop() {
        dispatchSource?.cancel()
        dispatchSource = nil
    }

    private func readInput() {
        var buf = [UInt8](repeating: 0, count: 16)
        let n = read(STDIN_FILENO, &buf, buf.count)
        guard n > 0 else { return }

        let bytes = Array(buf[0..<n])
        var i = 0
        while i < bytes.count {
            let key = parseKey(bytes: bytes, index: &i)
            handler(key)
        }
    }

    private func parseKey(bytes: [UInt8], index: inout Int) -> Key {
        let b = bytes[index]
        index += 1

        // Ctrl+C
        if b == 3 {
            return .ctrlC
        }

        // Escape
        if b == 27 {
            // Check for escape sequence
            guard index < bytes.count else { return .escape }

            if bytes[index] == 91 { // [
                index += 1
                guard index < bytes.count else { return .escape }

                let code = bytes[index]
                index += 1

                switch code {
                case 65: return .up
                case 66: return .down
                case 67: return .right
                case 68: return .left
                case 72: return .home
                case 70: return .end
                case 53: // 5~
                    if index < bytes.count && bytes[index] == 126 { index += 1 }
                    return .pageUp
                case 54: // 6~
                    if index < bytes.count && bytes[index] == 126 { index += 1 }
                    return .pageDown
                case 51: // 3~
                    if index < bytes.count && bytes[index] == 126 { index += 1 }
                    return .delete
                default:
                    // F1-F4: ESC O P/Q/R/S
                    return .unknown
                }
            } else if bytes[index] == 79 { // O
                index += 1
                guard index < bytes.count else { return .escape }
                let code = bytes[index]
                index += 1
                switch code {
                case 80: return .f(1)
                case 81: return .f(2)
                case 82: return .f(3)
                case 83: return .f(4)
                default: return .unknown
                }
            }

            return .escape
        }

        // Enter
        if b == 13 || b == 10 {
            return .enter
        }

        // Tab
        if b == 9 {
            return .tab
        }

        // Backspace
        if b == 127 || b == 8 {
            return .backspace
        }

        // Regular character (handle UTF-8)
        if b < 128 {
            return .char(Character(UnicodeScalar(b)))
        }

        // Multi-byte UTF-8
        let extraBytes: Int
        if b & 0xE0 == 0xC0 { extraBytes = 1 }
        else if b & 0xF0 == 0xE0 { extraBytes = 2 }
        else if b & 0xF8 == 0xF0 { extraBytes = 3 }
        else { return .unknown }

        guard index + extraBytes <= bytes.count else { return .unknown }
        var utf8Bytes = [b]
        for _ in 0..<extraBytes {
            utf8Bytes.append(bytes[index])
            index += 1
        }
        if let str = String(bytes: utf8Bytes, encoding: .utf8), let char = str.first {
            return .char(char)
        }
        return .unknown
    }
}
