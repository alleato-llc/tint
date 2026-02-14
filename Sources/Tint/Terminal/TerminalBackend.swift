public protocol TerminalBackend: AnyObject, Sendable {
    var size: Size { get }
    func draw(_ buffer: Buffer)
    func flush()
    func enableRawMode()
    func disableRawMode()
    func enterAlternateScreen()
    func exitAlternateScreen()
    func hideCursor()
    func showCursor()
}
