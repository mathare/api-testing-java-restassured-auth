#noinspection SpellCheckingInspection
Feature: "In Region" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "In Region" endpoint for the word "plonk"
    Then the response has a status code of 200
    And the response body follows the "InRegion" endpoint JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "In Region" endpoint for the word "freshman"
    Then the response has a status code of 200
    And the response body follows the "InRegion" endpoint JSON schema
    And the word field in the response body is "freshman"

  Scenario: Verify returned regions against data table
    When I make a GET request to the "In Region" endpoint for the word "anorak"
    Then the response has a status code of 200
    And the response body follows the "InRegion" endpoint JSON schema
    And the word is used in the following regions
      | britain                                              |
      | u.k.                                                 |
      | uk                                                   |
      | united kingdom                                       |
      | united kingdom of great britain and northern ireland |
      | great britain                                        |

  Scenario: Word has no regions
    When I make a GET request to the "In Region" endpoint for the word "porcupine"
    Then the response has a status code of 200
    And the response body follows the "InRegion" endpoint JSON schema
    And the word has no regions

  Scenario: Valid single letter word
    When I make a GET request to the "In Region" endpoint for the word "i"
    Then the response has a status code of 200
    And the response body follows the "InRegion" endpoint JSON schema
    And the word has no regions

  Scenario: Invalid single letter word
    When I make a GET request to the "In Region" endpoint for the word "n"
    Then the response has a status code of 200
    And the response body follows the "InRegion" endpoint JSON schema
    And the word has no regions

  Scenario: Get regions for number instead of word
    When I make a GET request to the "In Region" endpoint for the word "15"
    Then the response has a status code of 200
    And the response body follows the "InRegion" endpoint JSON schema
    And the word has no regions

  Scenario: Ordinal numbers have no regions
    When I make a GET request to the "In Region" endpoint for the word "7th"
    Then the response has a status code of 200
    And the response body follows the "InRegion" endpoint JSON schema
    And the word has no regions

  Scenario: Numbers as words have no regions
    When I make a GET request to the "In Region" endpoint for the word "nine"
    Then the response has a status code of 200
    And the response body follows the "InRegion" endpoint JSON schema
    And the word has no regions

  Scenario: Ordinal numbers as words have no regions
    When I make a GET request to the "In Region" endpoint for the word "fourth"
    Then the response has a status code of 200
    And the response body follows the "InRegion" endpoint JSON schema
    And the word has no regions

  Scenario: Valid multi-word phrase
    When I make a GET request to the "In Region" endpoint for the phrase "social security number"
    Then the response has a status code of 200
    And the response body follows the "InRegion" endpoint JSON schema
    And the phrase is used in the following regions
      | usa                      |
      | america                  |
      | the states               |
      | u.s.                     |
      | u.s.a.                   |
      | united states            |
      | united states of america |
      | us                       |

  Scenario: Hyphenated words
    When I make a GET request to the "In Region" endpoint for the word "go-slow"
    Then the response has a status code of 200
    And the response body follows the "InRegion" endpoint JSON schema
    And the word is used in the following regions
      | u.k.                                                 |
      | great britain                                        |
      | united kingdom of great britain and northern ireland |
      | britain                                              |
      | uk                                                   |
      | united kingdom                                       |

  Scenario: Words containing apostrophes
    When I make a GET request to the "In Region" endpoint for the word "shan't"
    Then the response has a status code of 200
    And the response body follows the "InRegion" endpoint JSON schema
    And the word has no regions

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "In Region" endpoint for the word "commune"
    And I make a GET request to the "In Region" endpoint for the word "cOmMuNe"
    And I make a GET request to the "In Region" endpoint for the word "COMMUNE"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "In Region" endpoint for the word "guv"
    Then the response has a status code of 200
    And the response body follows the "InRegion" endpoint JSON schema
    And the word has no regions

  Scenario: Valid initialism
    When I make a GET request to the "In Region" endpoint for the word "MB"
    Then the response has a status code of 200
    And the response body follows the "InRegion" endpoint JSON schema
    And the word is used in the following regions
      | u.k.                                                 |
      | great britain                                        |
      | britain                                              |
      | united kingdom of great britain and northern ireland |
      | united kingdom                                       |
      | uk                                                   |

  Scenario: Popular brand name
    When I make a GET request to the "In Region" endpoint for the word "coca-cola"
    Then the response has a status code of 200
    And the response body follows the "InRegion" endpoint JSON schema
    And the word has no regions

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "In Region" endpoint for the phrase "don juan"
    Then the response has a status code of 200
    And the response body follows the "InRegion" endpoint JSON schema
    And the phrase is used in the following regions
      | espana           |
      | kingdom of spain |
      | spain            |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "In Region" endpoint for the word "corner"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "In Region" endpoint for the word "corner"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "In Region" endpoint for the word "corner"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "In Region" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/inregion does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |