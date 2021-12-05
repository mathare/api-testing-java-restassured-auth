#noinspection SpellCheckingInspection
Feature: "Pertains To" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Pertains To" endpoint for the word "unitary"
    Then the response has a status code of 200
    And the response body follows the "PertainsTo" endpoint JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Pertains To" endpoint for the word "gladiatorial"
    Then the response has a status code of 200
    And the response body follows the "PertainsTo" endpoint JSON schema
    And the word field in the response body is "gladiatorial"

  Scenario: Verify returned values against data table
    When I make a GET request to the "Pertains To" endpoint for the word "extraterrestrial"
    Then the response has a status code of 200
    And the response body follows the "PertainsTo" endpoint JSON schema
    And the word pertains to the following
      | earth |

  Scenario: Word doesn't pertain to anything
    When I make a GET request to the "Pertains To" endpoint for the word "table"
    Then the response has a status code of 200
    And the response body follows the "PertainsTo" endpoint JSON schema
    And the word pertains to nothing

  Scenario: Valid single letter word
    When I make a GET request to the "Pertains To" endpoint for the word "i"
    Then the response has a status code of 200
    And the response body follows the "PertainsTo" endpoint JSON schema
    And the word pertains to nothing

  Scenario: Invalid single letter word
    When I make a GET request to the "Pertains To" endpoint for the word "t"
    Then the response has a status code of 200
    And the response body follows the "PertainsTo" endpoint JSON schema
    And the word pertains to nothing

  Scenario Outline: Numbers don't pertain to anything
    When I make a GET request to the "Pertains To" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the "PertainsTo" endpoint JSON schema
    And the word pertains to nothing
    Examples:
      | word |
      | 2    |
      | two  |

  Scenario Outline: Ordinal numbers don't pertain to anything
    When I make a GET request to the "Pertains To" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the "PertainsTo" endpoint JSON schema
    And the word pertains to nothing
    Examples:
      | word  |
      | 1st   |
      | first |

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Pertains To" endpoint for the phrase "roman catholic"
    Then the response has a status code of 200
    And the response body follows the "PertainsTo" endpoint JSON schema
    And the phrase pertains to the following
      | romanism |

  Scenario: Hyphenated words
    When I make a GET request to the "Pertains To" endpoint for the word "open-source"
    Then the response has a status code of 200
    And the response body follows the "PertainsTo" endpoint JSON schema
    And the word pertains to the following
      | source code |

  Scenario: Words containing apostrophes
    When I make a GET request to the "Pertains To" endpoint for the word "you'd"
    Then the response has a status code of 200
    And the response body follows the "PertainsTo" endpoint JSON schema
    And the word pertains to nothing

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Pertains To" endpoint for the word "speedily"
    And I make a GET request to the "Pertains To" endpoint for the word "sPEedILy"
    And I make a GET request to the "Pertains To" endpoint for the word "SPEEDILY"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Pertains To" endpoint for the word "kilo"
    Then the response has a status code of 200
    And the response body follows the "PertainsTo" endpoint JSON schema
    And the word pertains to nothing

  Scenario: Valid initialism
    When I make a GET request to the "Pertains To" endpoint for the word "VHF"
    Then the response has a status code of 200
    And the response body follows the "PertainsTo" endpoint JSON schema
    And the word pertains to nothing

  Scenario: Popular brand name
    When I make a GET request to the "Pertains To" endpoint for the word "yahoo"
    Then the response has a status code of 200
    And the response body follows the "PertainsTo" endpoint JSON schema
    And the word pertains to nothing

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "Pertains To" endpoint for the phrase "ad infinitum"
    Then the response has a status code of 200
    And the response body follows the "PertainsTo" endpoint JSON schema
    And the phrase pertains to the following
      | infinite |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Pertains To" endpoint for the word "river"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Pertains To" endpoint for the word "river"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Pertains To" endpoint for the word "river"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Pertains To" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/pertainsto does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |