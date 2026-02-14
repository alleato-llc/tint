# Test Design Philosophy

How Tint approaches testing and the reasoning behind the two-layer strategy.

## Why Two Test Layers

Tint is a rendering framework. Its core abstraction is simple: widgets are pure functions `(Rect, inout Buffer) -> Void`. This makes testing straightforward — assert on buffer content — but the *level* of testing matters.

### Unit Tests (Swift Testing)

Unit tests verify that individual types behave correctly in isolation. They answer: "does this function produce the right output for a given input?"

Examples in Tint:
- `Buffer.write(_:x:y:)` writes characters at the correct positions
- `Rect.intersection(_:)` computes the correct overlap
- `Style.merging(_:)` applies the correct override rules
- `Layout.split(_:)` distributes space according to constraints

Unit tests are the right tool when:
- The input/output boundary is clear (a function, a method, a computed property)
- No composition or interaction between types is involved
- Edge cases need exhaustive coverage (empty rects, out-of-bounds access, zero-width buffers)

### BDD Tests

BDD tests verify behavior from the user's perspective using natural-language Gherkin scenarios. They answer: "does this component behave the way a consumer expects?"

Examples in Tint:
- "When I render a Block with rounded border, the corner characters are correct"
- "When I render a list with a selected item, the highlight symbol appears"
- "When I merge an overlay style onto a base, non-default values override"

BDD tests are the right tool when:
- The scenario describes a **user-observable outcome**, not an implementation detail
- Multiple types compose together (Block + Text child, Layout + widget rendering)
- The test serves as **living documentation** of the framework's contract

### When to Use Each

| Test Type | Use For | Example |
|-----------|---------|---------|
| Unit tests | Pure functions, edge cases, isolated type behavior | `Buffer.fill(_:cell:)` fills the correct region |
| BDD tests | Composed behavior, rendering contracts, API documentation | "A Block with title renders the title at the correct position" |

When in doubt, prefer a BDD scenario if the behavior is something a framework consumer would care about. Prefer a unit test if you're testing an internal edge case.

## Testing Trophy Applied to Tint

```
          +----+
          | E2E|               <- Not applicable (no UI, no app lifecycle)
       +--+----+--+
       |          |
    +--+ Integr-  +--+
    |  |  ation   |  |        <- BDD: widget rendering, layout + widget composition
    |  |          |  |
    +--+----------+--+
       +----------+
       |   Unit   |            <- Swift Testing: Buffer, Rect, Cell, Style, Constraint
       +----------+
       +----------+
       |  Static  |            <- Swift compiler, type system
       +----------+
```

- **Static layer**: Swift's type system enforces `Widget` protocol conformance, `Sendable` correctness, and value semantics on core types.
- **Unit layer**: Swift Testing covers pure logic — buffer operations, rect math, style merging, constraint resolution.
- **Integration layer**: BDD scenarios exercise widgets rendering into buffers, layouts splitting areas, and styles composing. These are the primary confidence drivers for framework consumers.
- **E2E layer**: Not applicable. Tint is a library, not an application. Downstream apps (like aux) own their E2E tests.
