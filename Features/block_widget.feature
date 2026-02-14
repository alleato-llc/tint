Feature: Block Widget
  The Block widget renders a border with optional title and child content.

  Scenario: Plain border corners
    Given a buffer of width 10 and height 5
    When I render a Block with plain border
    Then cell (0, 0) should contain "┌"
    And cell (9, 0) should contain "┐"
    And cell (0, 4) should contain "└"
    And cell (9, 4) should contain "┘"

  Scenario: Rounded border corners
    Given a buffer of width 10 and height 5
    When I render a Block with rounded border
    Then cell (0, 0) should contain "╭"
    And cell (9, 0) should contain "╮"
    And cell (0, 4) should contain "╰"
    And cell (9, 4) should contain "╯"

  Scenario: Double border corners
    Given a buffer of width 10 and height 5
    When I render a Block with double border
    Then cell (0, 0) should contain "╔"
    And cell (9, 0) should contain "╗"
    And cell (0, 4) should contain "╚"
    And cell (9, 4) should contain "╝"

  Scenario: Title placement on border
    Given a buffer of width 20 and height 5
    When I render a Block with plain border and title "MyTitle"
    Then cell (3, 0) should contain "M"
    And row 0 should contain "MyTitle"

  Scenario: Child renders inside block
    Given a buffer of width 12 and height 5
    When I render a Block with plain border containing text "Hi"
    Then the buffer should contain text "Hi"
    And cell (1, 1) should contain "H"

  Scenario: Empty area does not crash
    Given an area of width 0 and height 0
    When I render a Block with plain border
    Then the buffer does not crash
