Feature: Layout
  Layout splits a Rect into sub-rects based on constraints and direction.

  Scenario: Vertical split with fixed and fill
    Given an area of width 20 and height 10
    When I split vertically with constraints: fixed(3), fill
    Then I should get 2 rects
    And rect 0 should have height 3
    And rect 1 should have height 7
    And all rects should have width 20

  Scenario: Horizontal split with fixed and fill
    Given an area of width 20 and height 10
    When I split horizontally with constraints: fixed(5), fill
    Then I should get 2 rects
    And rect 0 should have width 5
    And rect 1 should have width 15

  Scenario: Percentage constraint
    Given an area of width 20 and height 100
    When I split vertically with constraints: percentage(30), fill
    Then I should get 2 rects
    And rect 0 should have height 30
    And rect 1 should have height 70

  Scenario: Multiple fills divide equally
    Given an area of width 20 and height 12
    When I split vertically with constraints: fill, fill, fill
    Then I should get 3 rects
    And rect 0 should have height 4
    And rect 1 should have height 4
    And rect 2 should have height 4

  Scenario: Empty constraints produce no rects
    Given an area of width 20 and height 10
    When I split vertically with no constraints
    Then I should get 0 rects

  Scenario: Single fill takes entire area
    Given an area of width 20 and height 10
    When I split vertically with constraints: fill
    Then I should get 1 rect
    And rect 0 should equal the original area

  Scenario: Min constraint with remaining space
    Given an area of width 20 and height 10
    When I split vertically with constraints: min(3), fill
    Then I should get 2 rects
    And rect 0 should have height 7
    And rect 1 should have height 3
