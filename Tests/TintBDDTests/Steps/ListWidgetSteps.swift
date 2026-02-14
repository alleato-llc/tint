import PickleKit
import Tint

/// Given/When steps for ListWidget rendering.
struct ListWidgetSteps: StepDefinitions {
    init() {}

    /// Given list items: "A, B, C"
    let givenListItems = StepDefinition.given(
        #"list items: "([^"]*)""#
    ) { match in
        let ctx = TintTestContext.shared
        let itemsStr = match.captures[0]
        let items = itemsStr.split(separator: ",").map { item in
            ListWidget.Item(item.trimmingCharacters(in: .whitespaces))
        }
        ctx.listItems = items
    }

    /// Given N list items with prefix "..."
    let givenNListItems = StepDefinition.given(
        #"(\d+) list items with prefix "([^"]*)""#
    ) { match in
        let ctx = TintTestContext.shared
        let count = Int(match.captures[0])!
        let prefix = match.captures[1]
        ctx.listItems = (1...count).map { i in
            ListWidget.Item("\(prefix) \(i)")
        }
    }

    /// Given an empty list
    let givenEmptyList = StepDefinition.given(
        #"an empty list"#
    ) { _ in
        let ctx = TintTestContext.shared
        ctx.listItems = []
    }

    /// When I render the list widget
    let renderListWidget = StepDefinition.when(
        #"I render the list widget"#
    ) { _ in
        let ctx = TintTestContext.shared
        guard var buffer = ctx.buffer,
              let area = ctx.area else {
            throw TintStepError.setup("Buffer or area not initialized")
        }
        let widget = ListWidget(
            items: ctx.listItems,
            selected: ctx.selectedIndex
        )
        widget.render(area: area, buffer: &buffer)
        ctx.buffer = buffer
    }
}
