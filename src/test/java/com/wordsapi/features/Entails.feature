#noinspection SpellCheckingInspection
Feature: "Entails" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Entails" endpoint for the word "eat"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Entails" endpoint for the word "parachute"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "parachute"

  Scenario: Verify returned values against data table
    When I make a GET request to the "Entails" endpoint for the word "fight"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word entails the following
      | compete |
      | vie     |
      | contend |

  Scenario: Word doesn't entail anything
    When I make a GET request to the "Entails" endpoint for the word "blind"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word doesn't entail anything

  Scenario: Valid single letter word
    When I make a GET request to the "Entails" endpoint for the word "i"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word doesn't entail anything

  Scenario: Invalid single letter word
    When I make a GET request to the "Entails" endpoint for the word "o"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word doesn't entail anything

  Scenario: Numbers don't entail anything
    When I make a GET request to the "Entails" endpoint for the word "3"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word doesn't entail anything

  Scenario: Ordinal numbers don't entail anything
    When I make a GET request to the "Entails" endpoint for the word "6th"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word doesn't entail anything

  Scenario: Numbers as words don't entail anything
    When I make a GET request to the "Entails" endpoint for the word "eight"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word doesn't entail anything

  Scenario: Ordinal numbers as words don't entail anything
    When I make a GET request to the "Entails" endpoint for the word "fifth"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word doesn't entail anything

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Entails" endpoint for the phrase "pull through"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the phrase entails the following
      | convalesce |
      | recover    |
      | recuperate |

  Scenario: Hyphenated words
    When I make a GET request to the "Entails" endpoint for the word "freeze-dry"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word entails the following
      | desiccate |
      | dehydrate |
      | dry up    |
      | exsiccate |

  Scenario: Words containing apostrophes
    When I make a GET request to the "Entails" endpoint for the phrase "make up one's mind"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the phrase entails the following
      | debate     |
      | deliberate |

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Entails" endpoint for the word "salute"
    And I make a GET request to the "Entails" endpoint for the word "SALute"
    And I make a GET request to the "Entails" endpoint for the word "SALUTE"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Entails" endpoint for the word "kid"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word doesn't entail anything

  Scenario: Valid initialism
    When I make a GET request to the "Entails" endpoint for the word "ASAP"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word doesn't entail anything

  Scenario: Popular brand name
    When I make a GET request to the "Entails" endpoint for the word "toyota"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word doesn't entail anything

  Scenario: Valid foreign word used in English
    When I make a GET request to the "Entails" endpoint for the word "applique"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word entails the following
      | tailor-make |
      | sew         |
      | tailor      |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Entails" endpoint for the word "hallway"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Entails" endpoint for the word "hallway"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Entails" endpoint for the word "hallway"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Entails" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/entails does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |