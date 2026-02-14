public struct Buffer: Sendable {
    public let area: Rect
    public private(set) var cells: [Cell]

    public init(area: Rect) {
        self.area = area
        self.cells = Array(repeating: .empty, count: area.width * area.height)
    }

    // MARK: - Cell Access

    private func index(x: Int, y: Int) -> Int? {
        guard x >= area.x, x < area.right, y >= area.y, y < area.bottom else { return nil }
        return (y - area.y) * area.width + (x - area.x)
    }

    public subscript(x: Int, y: Int) -> Cell {
        get {
            guard let i = index(x: x, y: y) else { return .empty }
            return cells[i]
        }
        set {
            guard let i = index(x: x, y: y) else { return }
            cells[i] = newValue
        }
    }

    // MARK: - Writing

    /// Write a string starting at (x, y) with the given style. Truncates at buffer edge.
    public mutating func write(_ text: String, x: Int, y: Int, style: Style = .default) {
        var col = x
        for char in text {
            guard col < area.right else { break }
            if col >= area.x {
                self[col, y] = Cell(character: char, style: style)
            }
            col += 1
        }
    }

    /// Fill a rect region with the given cell.
    public mutating func fill(_ rect: Rect, cell: Cell = .empty) {
        let clipped = area.intersection(rect)
        for y in clipped.y..<clipped.bottom {
            for x in clipped.x..<clipped.right {
                self[x, y] = cell
            }
        }
    }

    /// Fill a rect region with a style, keeping existing characters.
    public mutating func setStyle(_ rect: Rect, style: Style) {
        let clipped = area.intersection(rect)
        for y in clipped.y..<clipped.bottom {
            for x in clipped.x..<clipped.right {
                if let i = index(x: x, y: y) {
                    cells[i].style = style
                }
            }
        }
    }

    /// Merge another buffer on top of this one. Only copies cells within the overlap region.
    public mutating func merge(_ other: Buffer) {
        let overlap = area.intersection(other.area)
        guard !overlap.isEmpty else { return }
        for y in overlap.y..<overlap.bottom {
            for x in overlap.x..<overlap.right {
                self[x, y] = other[x, y]
            }
        }
    }

    /// Reset all cells to empty.
    public mutating func reset() {
        cells = Array(repeating: .empty, count: area.width * area.height)
    }

    // MARK: - Inspection

    /// Extract text content of a single row (relative to buffer area).
    public func textAt(row: Int) -> String {
        let y = area.y + row
        guard y < area.bottom else { return "" }
        var result = ""
        for x in area.x..<area.right {
            result.append(self[x, y].character)
        }
        return result
    }

    /// Extract text content of all rows.
    public func allText() -> [String] {
        (0..<area.height).map { textAt(row: $0) }
    }
}
