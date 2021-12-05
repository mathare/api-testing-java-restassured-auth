Feature: "Antonyms" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Antonyms" endpoint for the word "present"
    Then the response has a status code of 200
    And the response body follows the "Antonyms" endpoint JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Antonyms" endpoint for the word "industrial"
    Then the response has a status code of 200
    And the response body follows the "Antonyms" endpoint JSON schema
    And the word field in the response body is "industrial"

  Scenario: Verify returned antonyms against data table
    When I make a GET request to the "Antonyms" endpoint for the word "brave"
    Then the response has a status code of 200
    And the response body follows the "Antonyms" endpoint JSON schema
    And the word has the following antonyms
      | cowardly |
      | timid    |

  Scenario: Word has no antonyms
    When I make a GET request to the "Antonyms" endpoint for the word "drape"
    Then the response has a status code of 200
    And the response body follows the "Antonyms" endpoint JSON schema
    And the word has no antonyms

  Scenario: Valid single letter word
    When I make a GET request to the "Antonyms" endpoint for the word "a"
    Then the response has a status code of 200
    And the response body follows the "Antonyms" endpoint JSON schema
    And the word has no antonyms

  # As valid single letter words have no antonyms, there are no test cases for invalid single letter words - there's no point

  Scenario: Get antonyms for number instead of word
    When I make a GET request to the "Antonyms" endpoint for the word "1"
    Then the response has a status code of 200
    And the response body follows the "Antonyms" endpoint JSON schema
    And the word has no antonyms

  # The previous test cases shows numbers have no antonyms so there are no further test cases for numbers here.
  # We've already shown numbers are valid as parameters so there is no value in showing they all have no antonyms

  Scenario: No antonyms for ordinal numbers
    When I make a GET request to the "Antonyms" endpoint for the word "2nd"
    Then the response has a status code of 200
    And the response body follows the "Antonyms" endpoint JSON schema
    And the word has no antonyms

  Scenario: Ordinal numbers and words can have different antonyms
    When I make a GET request to the "Antonyms" endpoint for the word "1st"
    And the word has no antonyms
    When I make a GET request to the "Antonyms" endpoint for the word "first"
    And the word has the following antonyms
      | second |
      | last   |

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Antonyms" endpoint for the phrase "direct current"
    Then the response has a status code of 200
    And the response body follows the "Antonyms" endpoint JSON schema
    And the phrase has the following antonyms
      | alternating current |

  Scenario: Hyphenated words
    When I make a GET request to the "Antonyms" endpoint for the word "full-time"
    Then the response has a status code of 200
    And the response body follows the "Antonyms" endpoint JSON schema
    And the word has the following antonyms
      | part-time |
      | half-time |

  Scenario: Words containing apostrophes
    When I make a GET request to the "Antonyms" endpoint for the word "can't"
    Then the response has a status code of 200
    And the response body follows the "Antonyms" endpoint JSON schema
    And the word has no antonyms

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Antonyms" endpoint for the word "black"
    And I make a GET request to the "Antonyms" endpoint for the word "bLaCk"
    And I make a GET request to the "Antonyms" endpoint for the word "BLACK"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Antonyms" endpoint for the word "pro"
    Then the response has a status code of 200
    And the response body follows the "Antonyms" endpoint JSON schema
    And the word has the following antonyms
      | con  |
      | anti |

  Scenario: Valid initialism
    When I make a GET request to the "Antonyms" endpoint for the word "MD"
    Then the response has a status code of 200
    And the response body follows the "Antonyms" endpoint JSON schema
    And the word has no antonyms

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "Antonyms" endpoint for the phrase "a la carte"
    Then the response has a status code of 200
    And the response body follows the "Antonyms" endpoint JSON schema
    And the phrase has the following antonyms
      | table d'hote |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Antonyms" endpoint for the word "tree"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Antonyms" endpoint for the word "tree"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Antonyms" endpoint for the word "tree"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Antonyms" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/antonyms does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |