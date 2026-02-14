import PickleKit
import Tint

/// Given/When steps for Table widget rendering.
struct TableWidgetSteps: StepDefinitions {
    init() {}

    /// Given a table with columns: (data table)
    let givenTableColumns = StepDefinition.given(
        #"a table with columns:$"#
    ) { match in
        let ctx = TintTestContext.shared
        guard let dataTable = match.dataTable else {
            throw TintStepError.setup("Expected a data table for columns")
        }
        ctx.tableColumns = dataTable.rows.map { row in
            Table.Column(row[0])
        }
    }

    /// Given table rows: (data table)
    let givenTableRows = StepDefinition.given(
        #"table rows:$"#
    ) { match in
        let ctx = TintTestContext.shared
        guard let dataTable = match.dataTable else {
            throw TintStepError.setup("Expected a data table for rows")
        }
        ctx.tableRows = dataTable.rows.map { row in
            Table.Row(row)
        }
    }

    /// Given an empty table
    let givenEmptyTable = StepDefinition.given(
        #"an empty table"#
    ) { _ in
        let ctx = TintTestContext.shared
        ctx.tableColumns = [Table.Column("Name"), Table.Column("Value")]
        ctx.tableRows = []
    }

    /// When I render the table widget
    let renderTableWidget = StepDefinition.when(
        #"I render the table widget"#
    ) { _ in
        let ctx = TintTestContext.shared
        guard var buffer = ctx.buffer,
              let area = ctx.area else {
            throw TintStepError.setup("Buffer or area not initialized")
        }
        let widget = Table(
            columns: ctx.tableColumns,
            rows: ctx.tableRows,
            selected: ctx.selectedIndex
        )
        widget.render(area: area, buffer: &buffer)
        ctx.buffer = buffer
    }
}
