import XCTest
@testable import Tint

final class ApplicationTests: XCTestCase {
    func testApplicationInit() {
        let backend = MockTerminalBackend(width: 80, height: 24)
        let app = Application(backend: backend)
        XCTAssertEqual(app.terminalSize, Size(width: 80, height: 24))
    }

    func testDefaultTheme() {
        let backend = MockTerminalBackend()
        let app = Application(backend: backend)
        XCTAssertTrue(app.theme is DefaultTheme)
    }

    func testCustomTheme() {
        struct TestTheme: Theme {
            var primary: Style { Style(fg: .green) }
            var secondary: Style { .default }
            var highlight: Style { .default }
            var accent: Style { .default }
            var muted: Style { .default }
            var border: Style { .default }
            var title: Style { .default }
            var error: Style { .default }
            var statusBar: Style { .default }
        }

        let backend = MockTerminalBackend()
        let app = Application(backend: backend, theme: TestTheme())
        XCTAssertTrue(app.theme is TestTheme)
    }

    func testMockBackendTracking() {
        let backend = MockTerminalBackend(width: 40, height: 10)

        XCTAssertFalse(backend.rawModeEnabled)
        backend.enableRawMode()
        XCTAssertTrue(backend.rawModeEnabled)
        backend.disableRawMode()
        XCTAssertFalse(backend.rawModeEnabled)

        XCTAssertFalse(backend.alternateScreenActive)
        backend.enterAlternateScreen()
        XCTAssertTrue(backend.alternateScreenActive)

        XCTAssertFalse(backend.cursorHidden)
        backend.hideCursor()
        XCTAssertTrue(backend.cursorHidden)

        let area = Rect(x: 0, y: 0, width: 40, height: 10)
        let buffer = Buffer(area: area)
        backend.draw(buffer)
        XCTAssertEqual(backend.drawCalls.count, 1)

        backend.flush()
        XCTAssertEqual(backend.flushCount, 1)
    }
}
