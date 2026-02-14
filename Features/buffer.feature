Feature: Buffer
  The Buffer stores a grid of styled cells and supports writing,
  filling, merging, and resetting operations.

  Scenario: Write text to buffer
    Given a buffer of width 10 and height 3
    When I write "Hello" at position (0, 0)
    Then row 0 should contain "Hello"

  Scenario: Text truncates at buffer edge
    Given a buffer of width 5 and height 1
    When I write "Hello World" at position (0, 0)
    Then row 0 should be exactly "Hello"

  Scenario: Write at offset position
    Given a buffer of width 10 and height 3
    When I write "Hi" at position (3, 1)
    Then row 1 should contain "Hi"
    And cell (3, 1) should contain "H"
    And cell (4, 1) should contain "i"

  Scenario: Fill region with character
    Given a buffer of width 6 and height 3
    When I fill the region (1, 0, 4, 2) with "X"
    Then cell (1, 0) should contain "X"
    And cell (4, 0) should contain "X"
    And cell (1, 1) should contain "X"
    And cell (0, 0) should contain " "

  Scenario: Merge overlapping buffers
    Given a buffer of width 10 and height 1
    When I write "AAAAAAAAAA" at position (0, 0)
    And I merge a buffer at (3, 0) of width 4 containing "BBBB"
    Then row 0 should contain "AAABBBBAAA"

  Scenario: Reset clears all content
    Given a buffer of width 5 and height 2
    When I write "Hello" at position (0, 0)
    And I write "World" at position (0, 1)
    And I reset the buffer
    Then all rows should be blank

  Scenario: Out-of-bounds write does not crash
    Given a buffer of width 5 and height 3
    When I write "Test" at position (10, 10)
    Then the buffer does not crash

  Scenario: Write on multiple rows
    Given a buffer of width 10 and height 3
    When I write "Line 1" at position (0, 0)
    And I write "Line 2" at position (0, 1)
    And I write "Line 3" at position (0, 2)
    Then row 0 should contain "Line 1"
    And row 1 should contain "Line 2"
    And row 2 should contain "Line 3"
