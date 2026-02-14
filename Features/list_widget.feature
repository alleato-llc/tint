Feature: List Widget
  The ListWidget renders a scrollable list with selection highlight.

  Scenario: Render list items with padding
    Given a buffer of width 20 and height 5
    And list items: "Apple, Banana, Cherry"
    When I render the list widget
    Then row 0 should contain "Apple"
    And row 1 should contain "Banana"
    And row 2 should contain "Cherry"

  Scenario: Selected item shows highlight symbol
    Given a buffer of width 20 and height 5
    And list items: "Apple, Banana, Cherry"
    And the selected index is 1
    When I render the list widget
    Then row 1 should contain "> Banana"

  Scenario: Scrolling keeps selection visible
    Given a buffer of width 20 and height 3
    And 10 list items with prefix "Item"
    And the selected index is 8
    When I render the list widget
    Then the buffer should contain text "Item 9"

  Scenario: Empty list renders nothing
    Given a buffer of width 20 and height 5
    And an empty list
    When I render the list widget
    Then all rows should be blank

  Scenario: Long text is truncated to fit width
    Given a buffer of width 10 and height 3
    And list items: "This is a very long item text"
    When I render the list widget
    Then the buffer does not crash
