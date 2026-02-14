import XCTest
@testable import Tint

final class ThemeTests: XCTestCase {
    func testDefaultThemeProperties() {
        let theme = DefaultTheme()
        XCTAssertTrue(theme.title.bold)
        XCTAssertTrue(theme.highlight.bold)
        XCTAssertTrue(theme.accent.bold)
        XCTAssertTrue(theme.error.bold)
        XCTAssertEqual(theme.error.fg, .red)
        XCTAssertEqual(theme.accent.fg, .cyan)
    }

    func testCustomTheme() {
        struct DarkTheme: Theme {
            var primary: Style { Style(fg: .white) }
            var secondary: Style { Style(fg: .brightBlack) }
            var highlight: Style { Style(fg: .yellow, bg: .blue) }
            var accent: Style { Style(fg: .green) }
            var muted: Style { Style(fg: .brightBlack) }
            var border: Style { Style(fg: .white) }
            var title: Style { Style(fg: .brightWhite, bold: true) }
            var error: Style { Style(fg: .brightRed) }
            var statusBar: Style { Style(bg: .blue) }
        }

        let theme = DarkTheme()
        XCTAssertEqual(theme.highlight.fg, .yellow)
        XCTAssertEqual(theme.highlight.bg, .blue)
    }
}
