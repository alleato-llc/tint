import Testing
@testable import Tint

@Suite struct StyleTests {
    @Test func defaultStyle() {
        let style = Style.default
        #expect(style.fg == .default)
        #expect(style.bg == .default)
        #expect(!style.bold)
        #expect(!style.italic)
        #expect(!style.underline)
        #expect(!style.dim)
        #expect(!style.reversed)
    }

    @Test func merging() {
        let base = Style(fg: .red, bold: true)
        let overlay = Style(fg: .blue)
        let merged = base.merging(overlay)
        #expect(merged.fg == .blue)
        #expect(merged.bg == .default)
        #expect(merged.bold)
    }

    @Test func mergingDefaultsPreserved() {
        let base = Style(fg: .green, bg: .yellow)
        let overlay = Style() // all defaults
        let merged = base.merging(overlay)
        // .default fg/bg don't override
        #expect(merged.fg == .green)
        #expect(merged.bg == .yellow)
    }

    @Test func ansiSequence() {
        let style = Style(fg: .red, bold: true)
        let seq = style.ansiSequence
        #expect(seq.contains("1")) // bold
        #expect(seq.contains("31")) // red fg
    }

    @Test func colorFgCodes() {
        #expect(Color.default.fgCode == "39")
        #expect(Color.red.fgCode == "31")
        #expect(Color.brightCyan.fgCode == "96")
        #expect(Color.ansi256(42).fgCode == "38;5;42")
        #expect(Color.rgb(10, 20, 30).fgCode == "38;2;10;20;30")
    }

    @Test func colorBgCodes() {
        #expect(Color.default.bgCode == "49")
        #expect(Color.blue.bgCode == "44")
        #expect(Color.ansi256(100).bgCode == "48;5;100")
        #expect(Color.rgb(255, 0, 128).bgCode == "48;2;255;0;128")
    }

    @Test func styleEquality() {
        let a = Style(fg: .red, bold: true)
        let b = Style(fg: .red, bold: true)
        let c = Style(fg: .blue, bold: true)
        #expect(a == b)
        #expect(a != c)
    }
}
