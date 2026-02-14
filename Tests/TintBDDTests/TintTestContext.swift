import Tint

/// Shared mutable state for tint BDD step definitions.
/// Reset per-scenario via `CommonSetupSteps.init()`.
///
/// Safe because BDD tests run `.serialized` and step handlers run `@MainActor`.
final class TintTestContext: @unchecked Sendable {
    nonisolated(unsafe) static var shared = TintTestContext()

    var buffer: Buffer?
    var area: Rect?
    var rects: [Rect] = []
    var baseStyle: Style?
    var overlayStyle: Style?
    var mergedStyle: Style?
    var selectedIndex: Int?
    var listItems: [ListWidget.Item] = []
    var tableColumns: [Table.Column] = []
    var tableRows: [Table.Row] = []

    func reset() {
        buffer = nil
        area = nil
        rects = []
        baseStyle = nil
        overlayStyle = nil
        mergedStyle = nil
        selectedIndex = nil
        listItems = []
        tableColumns = []
        tableRows = []
    }
}

enum TintStepError: Error, CustomStringConvertible {
    case setup(String)
    case assertion(String)

    var description: String {
        switch self {
        case let .setup(msg): "Setup error: \(msg)"
        case let .assertion(msg): "Assertion failed: \(msg)"
        }
    }
}
