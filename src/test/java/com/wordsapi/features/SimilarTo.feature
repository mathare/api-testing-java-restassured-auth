#noinspection SpellCheckingInspection
Feature: "Similar To" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Similar To" endpoint for the word "rough"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Similar To" endpoint for the word "unstoppable"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "unstoppable"

  Scenario: Verify returned values against data table
    When I make a GET request to the "Similar To" endpoint for the word "warm"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is similar to the following
      | excitable     |
      | enthusiastic  |
      | fresh         |
      | lively        |
      | warming       |
      | lukewarm      |
      | tepid         |
      | warmed        |
      | hot           |
      | close         |
      | near          |
      | nigh          |
      | cordial       |
      | hearty        |
      | uncomfortable |

  Scenario: Word isn't similar to anything
    When I make a GET request to the "Similar To" endpoint for the word "artichoke"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word isn't similar to anything

  Scenario: Valid single letter word
    When I make a GET request to the "Similar To" endpoint for the word "i"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is similar to the following
      | cardinal |

  Scenario: Invalid single letter word
    When I make a GET request to the "Similar To" endpoint for the word "s"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word isn't similar to anything

  Scenario: Number instead of word
    When I make a GET request to the "Similar To" endpoint for the word "0"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is similar to the following
      | cardinal |

  Scenario: Ordinal numbers
    When I make a GET request to the "Similar To" endpoint for the word "1st"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is similar to the following
      | ordinal |

  Scenario: Numbers as words
    When I make a GET request to the "Similar To" endpoint for the word "zero"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is similar to the following
      | cardinal |
      | no       |
      | ordinal  |

  Scenario Outline: Ordinal numbers as words
    When I make a GET request to the "Similar To" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is similar to <num> things
    Examples:
      | word  | num |
      | first | 19  |
      | third | 1   |

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Similar To" endpoint for the phrase "out of the blue"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is similar to the following
      | unexpected |

  Scenario: Hyphenated words
    When I make a GET request to the "Similar To" endpoint for the word "never-ending"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is similar to the following
      | continuous    |
      | uninterrupted |

  Scenario: Words containing apostrophes
    When I make a GET request to the "Similar To" endpoint for the phrase "on one's guard"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is similar to the following
      | wary |

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Similar To" endpoint for the word "spherical"
    And I make a GET request to the "Similar To" endpoint for the word "SpHeRiCaL"
    And I make a GET request to the "Similar To" endpoint for the word "SPHERICAL"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Similar To" endpoint for the word "jr."
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is similar to the following
      | junior |

  Scenario: Valid initialism
    When I make a GET request to the "Similar To" endpoint for the word "UFO"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word isn't similar to anything

  Scenario: Popular brand name
    When I make a GET request to the "Similar To" endpoint for the word "mercedes"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word isn't similar to anything

  Scenario: Valid foreign word used in English
    When I make a GET request to the "Similar To" endpoint for the word "nee"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is similar to the following
      | heritable   |
      | inheritable |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Similar To" endpoint for the word "park"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Similar To" endpoint for the word "park"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Similar To" endpoint for the word "park"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Similar To" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/similarto does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |