#noinspection SpellCheckingInspection
Feature: "Also" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Also" endpoint for the word "vulnerable"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Also" endpoint for the word "log"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "log"

  Scenario: Verify returned values against data table
    When I make a GET request to the "Also" endpoint for the word "tolerant"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following "also" values
      | patient    |
      | charitable |

  Scenario: Verify number of returned values
    When I make a GET request to the "Also" endpoint for the word "inedible"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 3 "also" values

  Scenario: Word has no "also" values
    When I make a GET request to the "Also" endpoint for the word "mouse"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no "also" values

  Scenario: Valid single letter word
    When I make a GET request to the "Also" endpoint for the word "a"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no "also" values

  Scenario: Invalid single letter word
    When I make a GET request to the "Also" endpoint for the word "w"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no "also" values

  Scenario Outline: Numbers have no "also" values
    When I make a GET request to the "Also" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no "also" values
    Examples:
      | word  |
      | 3     |
      | three |

  Scenario Outline: Ordinal numbers have no "also" values
    When I make a GET request to the "Also" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no "also" values
    Examples:
      | word   |
      | 2nd    |
      | second |

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Also" endpoint for the phrase "dress up"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the phrase has the following "also" values
      | dress |

  Scenario: Hyphenated words
    When I make a GET request to the "Also" endpoint for the word "right-handed"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following "also" values
      | dextral |
      | right   |

  Scenario: Words containing apostrophes
    When I make a GET request to the "Also" endpoint for the word "wouldn't"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no "also" values

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Also" endpoint for the word "weak"
    And I make a GET request to the "Also" endpoint for the word "WeaK"
    And I make a GET request to the "Also" endpoint for the word "WEAK"
    Then all response bodies are identical

  Scenario: Valid initialism
    When I make a GET request to the "Also" endpoint for the word "MD"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no "also" values

  Scenario: Popular brand name
    When I make a GET request to the "Also" endpoint for the word "tesla"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no "also" values

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "Also" endpoint for the phrase "a posteriori"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the phrase has the following "also" values
      | inductive   |
      | synthetic   |
      | synthetical |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Also" endpoint for the word "kitchen"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Also" endpoint for the word "kitchen"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Also" endpoint for the word "kitchen"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Also" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/also does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |