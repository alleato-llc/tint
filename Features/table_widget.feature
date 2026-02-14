Feature: Table Widget
  The Table widget renders columnar data with headers and row selection.

  Scenario: Render headers and rows
    Given a buffer of width 30 and height 6
    And a table with columns:
      | Name   |
      | Value  |
    And table rows:
      | Alpha | 100 |
      | Beta  | 200 |
    When I render the table widget
    Then row 0 should contain "Name"
    And row 0 should contain "Value"
    And the buffer should contain text "Alpha"
    And the buffer should contain text "Beta"

  Scenario: Selected row highlight
    Given a buffer of width 30 and height 6
    And a table with columns:
      | Name  |
      | Score |
    And table rows:
      | Alice | 95 |
      | Bob   | 87 |
    And the selected index is 0
    When I render the table widget
    Then the buffer should contain text "Alice"

  Scenario: Empty table renders only headers
    Given a buffer of width 30 and height 6
    And an empty table
    When I render the table widget
    Then row 0 should contain "Name"
    And row 0 should contain "Value"
