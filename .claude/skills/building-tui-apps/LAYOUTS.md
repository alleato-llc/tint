# Tint Layout System

## Layout

Splits a `Rect` into sub-rects by direction and constraints.

```swift
let layout = Layout(direction: .vertical, constraints: [
    .fixed(3),      // exactly 3 rows
    .fill,          // remaining space
    .fixed(1)       // exactly 1 row
])
let sections = layout.split(area)
// sections[0] = header, sections[1] = content, sections[2] = footer
```

**Direction**: `.vertical` (top to bottom), `.horizontal` (left to right)

## Constraints

| Constraint | Behavior |
|------------|----------|
| `.fixed(Int)` | Exact size in rows/columns |
| `.percentage(Int)` | Percentage of total available space |
| `.min(Int)` | At least N, participates in fill distribution |
| `.max(Int)` | At most N, participates in fill distribution |
| `.fill` | Takes remaining space equally with other fills |

## Nested layouts

```swift
let outer = Layout(direction: .vertical, constraints: [.fixed(3), .fill]).split(area)

let columns = Layout(direction: .horizontal, constraints: [
    .percentage(30),
    .fill
]).split(outer[1])

sidebar.render(area: columns[0], buffer: &buffer)
mainContent.render(area: columns[1], buffer: &buffer)
```

## Common patterns

**Header/content/footer**:
```swift
Layout(direction: .vertical, constraints: [.fixed(3), .fill, .fixed(1)])
```

**Sidebar + main**:
```swift
Layout(direction: .horizontal, constraints: [.fixed(20), .fill])
```

**Equal columns**:
```swift
Layout(direction: .horizontal, constraints: [.fill, .fill, .fill])
```

**Fixed + percentage + fill**:
```swift
Layout(direction: .horizontal, constraints: [.fixed(5), .percentage(40), .fill])
```
