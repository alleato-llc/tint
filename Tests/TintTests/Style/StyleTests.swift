import XCTest
@testable import Tint

final class StyleTests: XCTestCase {
    func testDefaultStyle() {
        let style = Style.default
        XCTAssertEqual(style.fg, .default)
        XCTAssertEqual(style.bg, .default)
        XCTAssertFalse(style.bold)
        XCTAssertFalse(style.italic)
        XCTAssertFalse(style.underline)
        XCTAssertFalse(style.dim)
        XCTAssertFalse(style.reversed)
    }

    func testMerging() {
        let base = Style(fg: .red, bold: true)
        let overlay = Style(fg: .blue)
        let merged = base.merging(overlay)
        XCTAssertEqual(merged.fg, .blue)
        XCTAssertEqual(merged.bg, .default)
        XCTAssertTrue(merged.bold)
    }

    func testMergingDefaultsPreserved() {
        let base = Style(fg: .green, bg: .yellow)
        let overlay = Style() // all defaults
        let merged = base.merging(overlay)
        // .default fg/bg don't override
        XCTAssertEqual(merged.fg, .green)
        XCTAssertEqual(merged.bg, .yellow)
    }

    func testAnsiSequence() {
        let style = Style(fg: .red, bold: true)
        let seq = style.ansiSequence
        XCTAssertTrue(seq.contains("1")) // bold
        XCTAssertTrue(seq.contains("31")) // red fg
    }

    func testColorFgCodes() {
        XCTAssertEqual(Color.default.fgCode, "39")
        XCTAssertEqual(Color.red.fgCode, "31")
        XCTAssertEqual(Color.brightCyan.fgCode, "96")
        XCTAssertEqual(Color.ansi256(42).fgCode, "38;5;42")
        XCTAssertEqual(Color.rgb(10, 20, 30).fgCode, "38;2;10;20;30")
    }

    func testColorBgCodes() {
        XCTAssertEqual(Color.default.bgCode, "49")
        XCTAssertEqual(Color.blue.bgCode, "44")
        XCTAssertEqual(Color.ansi256(100).bgCode, "48;5;100")
        XCTAssertEqual(Color.rgb(255, 0, 128).bgCode, "48;2;255;0;128")
    }

    func testStyleEquality() {
        let a = Style(fg: .red, bold: true)
        let b = Style(fg: .red, bold: true)
        let c = Style(fg: .blue, bold: true)
        XCTAssertEqual(a, b)
        XCTAssertNotEqual(a, c)
    }
}
