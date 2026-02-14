# Testing Conventions

## Framework: Swift Testing only

All tests in this project use **Swift Testing** (`import Testing`). Do NOT use XCTest.

### Required patterns

- `import Testing` (never `import XCTest`)
- `@Suite struct FooTests` (not `class FooTests: XCTestCase`)
- `@Test func descriptiveName()` (not `func testDescriptiveName()`)
- `#expect(condition)` for assertions (not `XCTAssert*`)
- `#expect(a == b)` (not `XCTAssertEqual`)
- `#expect(a != b)` (not `XCTAssertNotEqual`)
- `#expect(condition)` (not `XCTAssertTrue`)
- `#expect(!condition)` (not `XCTAssertFalse`)

### Buffer assertion helpers

Use the `Buffer` extension helpers which use `SourceLocation` for proper failure reporting:

```swift
buffer.assertRow(0, equals: "expected")
buffer.assertCell(x: 0, y: 0, char: "X")
buffer.assertStyle(x: 0, y: 0, Style(fg: .red))
```

### Running tests

```bash
swift test                              # All tests
swift test --filter TintTests           # Unit tests only
swift test --filter TintBDDTests        # BDD tests only
```
