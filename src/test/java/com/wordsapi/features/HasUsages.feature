#noinspection SpellCheckingInspection
Feature: "Has Usages" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Has Usages" endpoint for the word "acronym"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Has Usages" endpoint for the word "intensifier"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "intensifier"

  Scenario: Verify returned usages against data table
    When I make a GET request to the "Has Usages" endpoint for the word "synecdoche"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following usages
      | fireside |
      | face     |
      | hearth   |

  Scenario: Verify number of usages
    When I make a GET request to the "Has Usages" endpoint for the word "slang"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 195 usages

  Scenario: Word has no usages
    When I make a GET request to the "Has Usages" endpoint for the word "cutlery"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no usages

  Scenario: Valid single letter word
    When I make a GET request to the "Has Usages" endpoint for the word "a"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no usages

  Scenario: Invalid single letter word
    When I make a GET request to the "Has Usages" endpoint for the word "f"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no usages

  # There are no tests of numbers - as digits or words - or ordinal numbers as the "Has Usages" endpoint only really
  # makes sense when the word parameter is a category of words e.g. slang

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Has Usages" endpoint for the phrase "figure of speech"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the phrase has 21 usages

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Has Usages" endpoint for the word "trope"
    And I make a GET request to the "Has Usages" endpoint for the word "TrOpE"
    And I make a GET request to the "Has Usages" endpoint for the word "TROPE"
    Then all response bodies are identical

  Scenario: Valid foreign word used in English
    When I make a GET request to the "Has Usages" endpoint for the word "portmanteau"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following usages
      | smogginess |
      | dandle     |
      | brunch     |
      | motel      |
      | shopaholic |
      | smog       |
      | workaholic |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Has Usages" endpoint for the word "jargon"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Has Usages" endpoint for the word "jargon"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Has Usages" endpoint for the word "jargon"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Has Usages" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/hasusages does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |