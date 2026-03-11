# Tint Styles and Colors

## Color

```swift
// Named colors
Color.red, .green, .blue, .yellow, .cyan, .magenta, .white, .black

// Bright variants
Color.brightRed, .brightGreen, .brightBlue, .brightYellow,
     .brightCyan, .brightMagenta, .brightWhite, .brightBlack

// ANSI 256 palette
Color.ansi256(196)   // bright red

// True color RGB
Color.rgb(255, 128, 0)  // orange

// No color (terminal default)
Color.default
```

## Style

Combines colors with text attributes.

```swift
Style(
    fg: .cyan,           // foreground color
    bg: .default,        // background color
    bold: true,
    italic: false,
    underline: false,
    dim: false,
    reversed: false      // swap fg/bg
)
```

Shorthand: `Style(fg: .red, bold: true)` — unspecified attributes default to off/`.default`.

## Style merging

`style.merging(overlay)` — non-default values in `overlay` override `self`. Boolean attributes OR together.

```swift
let base = Style(fg: .white, bold: true)
let overlay = Style(fg: .red)
let merged = base.merging(overlay)
// Result: fg=.red, bold=true (red overrides white, bold preserved)
```

## Theme

Protocol with semantic style slots. Create custom themes:

```swift
struct MyTheme: Theme {
    var primary: Style { Style(fg: .white) }
    var secondary: Style { Style(fg: .brightBlack) }
    var highlight: Style { Style(fg: .black, bg: .cyan, bold: true) }
    var accent: Style { Style(fg: .green, bold: true) }
    var muted: Style { Style(fg: .brightBlack, dim: true) }
    var border: Style { Style(fg: .brightBlack) }
    var title: Style { Style(fg: .white, bold: true) }
    var error: Style { Style(fg: .red, bold: true) }
    var statusBar: Style { Style(fg: .white, bg: .brightBlack) }
}

let app = Application(theme: MyTheme())
```

## Applying styles

```swift
// Via widget constructors
Text("Hello", style: Style(fg: .green))

// Via buffer directly
buffer.write("text", x: 0, y: 0, style: Style(fg: .red, bold: true))
buffer.setStyle(rect, style: Style(bg: .blue))  // change style, keep characters
```
