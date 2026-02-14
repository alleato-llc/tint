import Tint

public final class MockTerminalBackend: TerminalBackend, @unchecked Sendable {
    public var mockSize: Size
    public private(set) var drawCalls: [Buffer] = []
    public private(set) var flushCount = 0
    public private(set) var rawModeEnabled = false
    public private(set) var alternateScreenActive = false
    public private(set) var cursorHidden = false

    public init(width: Int = 80, height: Int = 24) {
        self.mockSize = Size(width: width, height: height)
    }

    public var size: Size { mockSize }

    public func draw(_ buffer: Buffer) {
        drawCalls.append(buffer)
    }

    public func flush() {
        flushCount += 1
    }

    public func enableRawMode() {
        rawModeEnabled = true
    }

    public func disableRawMode() {
        rawModeEnabled = false
    }

    public func enterAlternateScreen() {
        alternateScreenActive = true
    }

    public func exitAlternateScreen() {
        alternateScreenActive = false
    }

    public func hideCursor() {
        cursorHidden = true
    }

    public func showCursor() {
        cursorHidden = false
    }

    /// Returns the last drawn buffer, or nil if no draws happened.
    public var lastBuffer: Buffer? {
        drawCalls.last
    }
}
