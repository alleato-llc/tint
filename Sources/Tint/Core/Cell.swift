public struct Cell: Equatable, Sendable {
    public var character: Character
    public var style: Style

    public init(character: Character = " ", style: Style = .default) {
        self.character = character
        self.style = style
    }

    public static let empty = Cell()

    public mutating func reset() {
        character = " "
        style = .default
    }
}
