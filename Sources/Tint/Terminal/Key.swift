public enum Key: Equatable, Hashable, Sendable {
    case char(Character)
    case enter
    case escape
    case backspace
    case tab
    case up
    case down
    case left
    case right
    case home
    case end
    case pageUp
    case pageDown
    case delete
    case f(Int)
    case scrollUp
    case scrollDown
    case ctrlC
    case unknown
}
