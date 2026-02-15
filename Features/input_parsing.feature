Feature: Input Parsing
  The InputReader parses raw terminal bytes into Key events,
  including ANSI escape sequences and SGR mouse events.

  # --- Regular characters ---

  Scenario: Parse a lowercase letter
    Given input bytes [97]
    When the bytes are parsed
    Then the parsed key should be char "a"

  Scenario: Parse a digit
    Given input bytes [49]
    When the bytes are parsed
    Then the parsed key should be char "1"

  # --- Control characters ---

  Scenario: Parse Ctrl+C
    Given input bytes [3]
    When the bytes are parsed
    Then the parsed key should be ctrlC

  Scenario: Parse Enter via carriage return
    Given input bytes [13]
    When the bytes are parsed
    Then the parsed key should be enter

  Scenario: Parse Enter via newline
    Given input bytes [10]
    When the bytes are parsed
    Then the parsed key should be enter

  Scenario: Parse Tab
    Given input bytes [9]
    When the bytes are parsed
    Then the parsed key should be tab

  Scenario: Parse Backspace
    Given input bytes [127]
    When the bytes are parsed
    Then the parsed key should be backspace

  Scenario: Parse Escape
    Given input bytes [27]
    When the bytes are parsed
    Then the parsed key should be escape

  # --- Arrow keys ---

  Scenario: Parse up arrow
    Given input bytes [27, 91, 65]
    When the bytes are parsed
    Then the parsed key should be up

  Scenario: Parse down arrow
    Given input bytes [27, 91, 66]
    When the bytes are parsed
    Then the parsed key should be down

  Scenario: Parse right arrow
    Given input bytes [27, 91, 67]
    When the bytes are parsed
    Then the parsed key should be right

  Scenario: Parse left arrow
    Given input bytes [27, 91, 68]
    When the bytes are parsed
    Then the parsed key should be left

  # --- Navigation keys ---

  Scenario: Parse Home key
    Given input bytes [27, 91, 72]
    When the bytes are parsed
    Then the parsed key should be home

  Scenario: Parse End key
    Given input bytes [27, 91, 70]
    When the bytes are parsed
    Then the parsed key should be end

  Scenario: Parse Page Up
    Given input bytes [27, 91, 53, 126]
    When the bytes are parsed
    Then the parsed key should be pageUp

  Scenario: Parse Page Down
    Given input bytes [27, 91, 54, 126]
    When the bytes are parsed
    Then the parsed key should be pageDown

  Scenario: Parse Delete key
    Given input bytes [27, 91, 51, 126]
    When the bytes are parsed
    Then the parsed key should be delete

  # --- Function keys ---

  Scenario: Parse F1 key
    Given input bytes [27, 79, 80]
    When the bytes are parsed
    Then the parsed key should be f1

  Scenario: Parse F2 key
    Given input bytes [27, 79, 81]
    When the bytes are parsed
    Then the parsed key should be f2

  Scenario: Parse F3 key
    Given input bytes [27, 79, 82]
    When the bytes are parsed
    Then the parsed key should be f3

  Scenario: Parse F4 key
    Given input bytes [27, 79, 83]
    When the bytes are parsed
    Then the parsed key should be f4

  # --- Mouse scroll events (SGR mode) ---

  Scenario: Parse mouse scroll up
    Given SGR mouse bytes for button 64 at 1,1
    When the bytes are parsed
    Then the parsed key should be scrollUp

  Scenario: Parse mouse scroll down
    Given SGR mouse bytes for button 65 at 1,1
    When the bytes are parsed
    Then the parsed key should be scrollDown

  Scenario: Parse mouse click is ignored
    Given SGR mouse bytes for button 0 at 10,5
    When the bytes are parsed
    Then the parsed key should be unknown

  # --- Multiple keys in one read ---

  Scenario: Parse multiple characters in sequence
    Given input bytes [104, 105]
    When the bytes are parsed
    Then 2 keys should be parsed
    And parsed key 0 should be char "h"
    And parsed key 1 should be char "i"
