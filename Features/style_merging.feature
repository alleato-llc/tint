Feature: Style Merging
  Styles merge by overriding non-default values and OR-ing boolean attributes.

  Scenario: Overlay foreground overrides base
    Given a base style with foreground "red"
    And an overlay style with foreground "blue"
    When I merge the overlay onto the base
    Then the merged foreground should be "blue"

  Scenario: Default overlay preserves base foreground
    Given a base style with foreground "green"
    And an overlay style with default foreground
    When I merge the overlay onto the base
    Then the merged foreground should be "green"

  Scenario: Boolean attributes are OR'd
    Given a base style with bold and italic
    And an overlay style with underline
    When I merge the overlay onto the base
    Then the merged style should have bold enabled
    And the merged style should have italic enabled
    And the merged style should have underline enabled

  Scenario: Merging two defaults produces default
    Given a base style with default values
    And an overlay style with default values
    When I merge the overlay onto the base
    Then the merged style should equal the default style

  Scenario: Overlay with foreground and background
    Given a base style with foreground "red" and background "blue"
    And an overlay style with foreground "green"
    When I merge the overlay onto the base
    Then the merged foreground should be "green"
