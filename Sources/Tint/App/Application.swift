import Foundation

/// Main entry point for a Tint TUI application.
/// Owns the terminal backend and input reader; provides a render loop.
public final class Application: @unchecked Sendable {
    public let backend: any TerminalBackend
    public var theme: any Theme
    private var inputReader: InputReader?
    private var running = false
    private var renderCallback: ((Rect, inout Buffer) -> Void)?
    private var renderSource: DispatchSourceTimer?

    public init(backend: (any TerminalBackend)? = nil, theme: (any Theme)? = nil) {
        self.backend = backend ?? ANSITerminal()
        self.theme = theme ?? DefaultTheme()
    }

    public var terminalSize: Size {
        backend.size
    }

    /// Start the application loop. This function does not return until `quit()` is called.
    /// - Parameters:
    ///   - render: Called on each frame to draw UI into the buffer.
    ///   - onKey: Called for each key press.
    public func run(
        render: @escaping (Rect, inout Buffer) -> Void,
        onKey: @escaping @Sendable (Key) -> Void
    ) {
        running = true
        renderCallback = render

        backend.enableRawMode()
        backend.enterAlternateScreen()
        backend.hideCursor()

        // Initial render
        performRender()

        // Set up periodic render (for dynamic content like progress bars)
        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now(), repeating: .milliseconds(100))
        timer.setEventHandler { [weak self] in
            self?.performRender()
        }
        timer.resume()
        renderSource = timer

        // Input handling
        let reader = InputReader { [weak self] key in
            guard let self, self.running else { return }
            onKey(key)
            self.performRender()
        }
        reader.start()
        inputReader = reader

        // Run the main dispatch loop
        dispatchMain()
    }

    /// Request an immediate re-render on the next loop iteration.
    public func requestRender() {
        DispatchQueue.main.async { [weak self] in
            self?.performRender()
        }
    }

    /// Stop the application and restore the terminal.
    public func quit() {
        running = false
        renderSource?.cancel()
        renderSource = nil
        inputReader?.stop()
        inputReader = nil
        backend.showCursor()
        backend.exitAlternateScreen()
        backend.disableRawMode()
        exit(0)
    }

    private func performRender() {
        guard running, let renderCallback else { return }
        let size = backend.size
        let area = Rect(x: 0, y: 0, width: size.width, height: size.height)
        var buffer = Buffer(area: area)
        renderCallback(area, &buffer)
        backend.draw(buffer)
        backend.flush()
    }
}
