public struct Position: Equatable, Hashable, Sendable {
    public var x: Int
    public var y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

public struct Size: Equatable, Hashable, Sendable {
    public var width: Int
    public var height: Int

    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }

    public static let zero = Size(width: 0, height: 0)
}

public struct Rect: Equatable, Hashable, Sendable {
    public var x: Int
    public var y: Int
    public var width: Int
    public var height: Int

    public init(x: Int, y: Int, width: Int, height: Int) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    public var position: Position {
        Position(x: x, y: y)
    }

    public var size: Size {
        Size(width: width, height: height)
    }

    public var right: Int { x + width }
    public var bottom: Int { y + height }
    public var area: Int { width * height }
    public var isEmpty: Bool { width == 0 || height == 0 }

    public func intersection(_ other: Rect) -> Rect {
        let x1 = max(x, other.x)
        let y1 = max(y, other.y)
        let x2 = min(right, other.right)
        let y2 = min(bottom, other.bottom)
        let w = max(0, x2 - x1)
        let h = max(0, y2 - y1)
        return Rect(x: x1, y: y1, width: w, height: h)
    }

    public func contains(_ position: Position) -> Bool {
        position.x >= x && position.x < right && position.y >= y && position.y < bottom
    }

    /// Returns a new rect inset by the given amount on each side.
    public func inset(top: Int = 0, right r: Int = 0, bottom b: Int = 0, left l: Int = 0) -> Rect {
        let newX = x + l
        let newY = y + top
        let newW = max(0, width - l - r)
        let newH = max(0, height - top - b)
        return Rect(x: newX, y: newY, width: newW, height: newH)
    }

    /// Inset by 1 on all sides (useful for border content areas).
    public var inner: Rect {
        inset(top: 1, right: 1, bottom: 1, left: 1)
    }

    public static let zero = Rect(x: 0, y: 0, width: 0, height: 0)
}
