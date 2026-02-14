public enum Constraint: Equatable, Sendable {
    case fixed(Int)
    case percentage(Int)
    case min(Int)
    case max(Int)
    case fill
}

public enum Direction: Sendable {
    case horizontal
    case vertical
}
