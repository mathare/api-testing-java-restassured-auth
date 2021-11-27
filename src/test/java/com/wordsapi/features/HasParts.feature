#noinspection SpellCheckingInspection
Feature: "Has Parts" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Has Parts" endpoint for the word "body"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Has Parts" endpoint for the word "letter"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "letter"

  Scenario: Verify returned parts against data table
    When I make a GET request to the "Has Parts" endpoint for the word "movie"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following parts
      | subtitle |
      | shot     |
      | sequence |
      | scene    |
      | episode  |
      | credits  |
      | credit   |
      | caption  |

  Scenario: Verify number of parts
    When I make a GET request to the "Has Parts" endpoint for the word "play"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 16 parts

  Scenario: Word has no parts
    When I make a GET request to the "Has Parts" endpoint for the word "astonishment"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no parts

  Scenario: Valid single letter word
    When I make a GET request to the "Has Parts" endpoint for the word "a"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following parts
      | milliampere |
      | ma          |
      | picometer   |
      | micromicron |
      | picometre   |

  Scenario: Invalid single letter word
    When I make a GET request to the "Has Parts" endpoint for the word "r"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no parts

  Scenario: Numbers have no parts
    When I make a GET request to the "Has Parts" endpoint for the word "75"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no parts

  Scenario: Ordinal numbers have no parts
    When I make a GET request to the "Has Parts" endpoint for the word "6th"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no parts

  Scenario: Numbers as words have no parts
    When I make a GET request to the "Has Parts" endpoint for the word "one"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no parts

  Scenario: Ordinal numbers and words have different parts
    When I make a GET request to the "Has Parts" endpoint for the word "2nd"
    Then the word has no parts
    When I make a GET request to the "Has Parts" endpoint for the word "second"
    Then the word has the following parts
      | msec        |
      | millisecond |

  Scenario: Not all ordinal numbers as words have parts
    When I make a GET request to the "Has Parts" endpoint for the word "first"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no parts

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Has Parts" endpoint for the phrase "sports stadium"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the phrase has the following parts
      | tiered seat    |
      | athletic field |
      | field          |
      | field house    |
      | playing area   |
      | playing field  |
      | stand          |
      | standing room  |

  Scenario: Hyphenated words
    When I make a GET request to the "Has Parts" endpoint for the word "small-arm"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following parts
      | firing pin |
      | sights     |
      | lock       |

  Scenario: Words containing apostrophes
    When I make a GET request to the "Has Parts" endpoint for the word "wouldn't"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no parts

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Has Parts" endpoint for the word "molecule"
    And I make a GET request to the "Has Parts" endpoint for the word "MOleCUle"
    And I make a GET request to the "Has Parts" endpoint for the word "MOLECULE"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Has Parts" endpoint for the word "min"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following parts
      | s      |
      | sec    |
      | second |

  Scenario: Valid initialism
    When I make a GET request to the "Has Parts" endpoint for the word "MB"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following parts
      | kb       |
      | k        |
      | kib      |
      | kibibyte |
      | kilobyte |
      | kbit     |
      | kilobit  |

  Scenario: Valid foreign word used in English
    When I make a GET request to the "Has Parts" endpoint for the word "tete-a-tete"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no parts

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Has Parts" endpoint for the word "chimney"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Has Parts" endpoint for the word "chimney"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Has Parts" endpoint for the word "chimney"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Has Parts" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/hasparts does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |