import Testing
@testable import Tint

@Suite struct ThemeTests {
    @Test func defaultThemeProperties() {
        let theme = DefaultTheme()
        #expect(theme.title.bold)
        #expect(theme.highlight.bold)
        #expect(theme.accent.bold)
        #expect(theme.error.bold)
        #expect(theme.error.fg == .red)
        #expect(theme.accent.fg == .cyan)
    }

    @Test func customTheme() {
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
        #expect(theme.highlight.fg == .yellow)
        #expect(theme.highlight.bg == .blue)
    }
}
