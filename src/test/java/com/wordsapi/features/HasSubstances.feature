#noinspection SpellCheckingInspection
Feature: "Has Substances" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Has Substances" endpoint for the word "brine"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Has Substances" endpoint for the word "bread"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "bread"

  Scenario: Verify returned substances against data table
    When I make a GET request to the "Has Substances" endpoint for the word "manhattan"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following substances
      | italian vermouth |
      | whisky           |
      | whiskey          |
      | sweet vermouth   |

  Scenario: Word has no substances
    When I make a GET request to the "Has Substances" endpoint for the word "party"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no substances

  Scenario: Valid single letter word
    When I make a GET request to the "Has Substances" endpoint for the word "a"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no substances

  Scenario: Invalid single letter word
    When I make a GET request to the "Has Substances" endpoint for the word "b"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no substances

  Scenario: Numbers have no substances
    When I make a GET request to the "Has Substances" endpoint for the word "2"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no substances

  Scenario: Ordinal numbers have no substances
    When I make a GET request to the "Has Substances" endpoint for the word "2nd"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no substances

  Scenario: Numbers as words have no substances
    When I make a GET request to the "Has Substances" endpoint for the word "one"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no substances

  Scenario: Ordinal numbers as words have no substances
    When I make a GET request to the "Has Substances" endpoint for the word "first"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no substances

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Has Substances" endpoint for the phrase "weed killer"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the phrase has the following substances
      | atomic number 33 |
      | arsenic          |
      | as               |

  Scenario: Hyphenated words
    When I make a GET request to the "Has Substances" endpoint for the word "a-horizon"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following substances
      | humus |

  Scenario: Words containing apostrophes
    When I make a GET request to the "Has Substances" endpoint for the word "shouldn't"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no substances

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Has Substances" endpoint for the word "padding"
    And I make a GET request to the "Has Substances" endpoint for the word "PaDdInG"
    And I make a GET request to the "Has Substances" endpoint for the word "PADDING"
    Then all response bodies are identical

  Scenario: Popular brand name
    When I make a GET request to the "Has Substances" endpoint for the phrase "tabasco sauce"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the phrase has the following substances
      | red pepper |
      | tabasco    |

  Scenario: Valid foreign word used in English
    When I make a GET request to the "Has Substances" endpoint for the word "jalapeno"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following substances
      | cayenne pepper |
      | cayenne        |
      | red pepper     |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Has Substances" endpoint for the word "serum"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Has Substances" endpoint for the word "serum"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Has Substances" endpoint for the word "serum"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Has Substances" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/hassubstances does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |