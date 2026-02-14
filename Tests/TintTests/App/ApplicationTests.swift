import Testing
@testable import Tint

@Suite struct ApplicationTests {
    @Test func applicationInit() {
        let backend = MockTerminalBackend(width: 80, height: 24)
        let app = Application(backend: backend)
        #expect(app.terminalSize == Size(width: 80, height: 24))
    }

    @Test func defaultTheme() {
        let backend = MockTerminalBackend()
        let app = Application(backend: backend)
        #expect(app.theme is DefaultTheme)
    }

    @Test func customTheme() {
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
        #expect(app.theme is TestTheme)
    }

    @Test func mockBackendTracking() {
        let backend = MockTerminalBackend(width: 40, height: 10)

        #expect(!backend.rawModeEnabled)
        backend.enableRawMode()
        #expect(backend.rawModeEnabled)
        backend.disableRawMode()
        #expect(!backend.rawModeEnabled)

        #expect(!backend.alternateScreenActive)
        backend.enterAlternateScreen()
        #expect(backend.alternateScreenActive)

        #expect(!backend.cursorHidden)
        backend.hideCursor()
        #expect(backend.cursorHidden)

        let area = Rect(x: 0, y: 0, width: 40, height: 10)
        let buffer = Buffer(area: area)
        backend.draw(buffer)
        #expect(backend.drawCalls.count == 1)

        backend.flush()
        #expect(backend.flushCount == 1)
    }
}
