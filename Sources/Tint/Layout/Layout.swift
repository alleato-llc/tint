/// Splits a rect into sub-rects based on constraints and direction.
public struct Layout: Sendable {
    public let direction: Direction
    public let constraints: [Constraint]

    public init(direction: Direction = .vertical, constraints: [Constraint]) {
        self.direction = direction
        self.constraints = constraints
    }

    /// Split the given area into sub-rects.
    public func split(_ area: Rect) -> [Rect] {
        guard !constraints.isEmpty else { return [] }

        let totalSize = direction == .horizontal ? area.width : area.height
        let sizes = resolve(constraints: constraints, total: totalSize)

        var result: [Rect] = []
        var offset = 0

        for size in sizes {
            switch direction {
            case .horizontal:
                result.append(Rect(x: area.x + offset, y: area.y, width: size, height: area.height))
            case .vertical:
                result.append(Rect(x: area.x, y: area.y + offset, width: area.width, height: size))
            }
            offset += size
        }

        return result
    }

    private func resolve(constraints: [Constraint], total: Int) -> [Int] {
        var sizes = Array(repeating: 0, count: constraints.count)
        var remaining = total
        var fillIndices: [Int] = []

        // First pass: resolve fixed, percentage, min, max
        for (i, constraint) in constraints.enumerated() {
            switch constraint {
            case .fixed(let n):
                sizes[i] = Swift.min(n, remaining)
                remaining -= sizes[i]
            case .percentage(let pct):
                sizes[i] = Swift.min(total * pct / 100, remaining)
                remaining -= sizes[i]
            case .min(let n):
                sizes[i] = Swift.min(n, remaining)
                remaining -= sizes[i]
                fillIndices.append(i)
            case .max(let n):
                // Will be resolved in fill pass, but record max
                sizes[i] = 0
                fillIndices.append(i)
                _ = n // used below
            case .fill:
                fillIndices.append(i)
            }
        }

        // Second pass: distribute remaining to fill/min/max
        if !fillIndices.isEmpty && remaining > 0 {
            let perFill = remaining / fillIndices.count
            var extra = remaining % fillIndices.count

            for idx in fillIndices {
                let added = perFill + (extra > 0 ? 1 : 0)
                if extra > 0 { extra -= 1 }

                switch constraints[idx] {
                case .max(let n):
                    sizes[idx] = Swift.min(n, added)
                case .min:
                    sizes[idx] += added
                case .fill:
                    sizes[idx] = added
                default:
                    break
                }
            }
        }

        return sizes
    }
}
