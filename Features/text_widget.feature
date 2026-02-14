Feature: Text Widget
  The Text widget renders styled text with alignment support.

  Scenario: Render single line of text
    Given a buffer of width 10 and height 3
    When I render a Text widget with content "Hello"
    Then row 0 should contain "Hello"

  Scenario: Render multi-line text
    Given a buffer of width 10 and height 3
    When I render a Text widget with lines "Line A" and "Line B"
    Then row 0 should contain "Line A"
    And row 1 should contain "Line B"

  Scenario: Center-aligned text
    Given a buffer of width 10 and height 1
    When I render a Text widget with content "Hi" aligned center
    Then row 0 should contain "Hi"
    And cell (4, 0) should contain "H"

  Scenario: Right-aligned text
    Given a buffer of width 10 and height 1
    When I render a Text widget with content "Hi" aligned right
    Then cell (8, 0) should contain "H"
    And cell (9, 0) should contain "i"

  Scenario: Text truncated horizontally
    Given a buffer of width 5 and height 1
    When I render a Text widget with content "Hello World"
    Then row 0 should be exactly "Hello"

  Scenario: Empty area does not crash
    Given an area of width 0 and height 0
    When I render a Text widget with content "Test"
    Then the buffer does not crash
