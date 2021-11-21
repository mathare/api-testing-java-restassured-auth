#noinspection SpellCheckingInspection
Feature: "Part Of" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Part Of" endpoint for the word "finger"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Part Of" endpoint for the word "foyer"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "foyer"

  Scenario: Verify returned parts against data table
    When I make a GET request to the "Part Of" endpoint for the word "lid"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is a part of the following
      | oculus |
      | eye    |
      | optic  |
      | jar    |
      | chest  |
      | box    |

  Scenario: Verify number of returned parts
    When I make a GET request to the "Part Of" endpoint for the word "handle"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is a part of 43 things

  Scenario: Word is not part of anything
    When I make a GET request to the "Part Of" endpoint for the word "yellow"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not a part of anything

  Scenario: Valid single letter word
    When I make a GET request to the "Part Of" endpoint for the word "a"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is a part of the following
      | abamp           |
      | abampere        |
      | micromillimetre |
      | nanometer       |
      | millimicron     |
      | nanometre       |
      | nm              |
      | micromillimeter |

  Scenario: Invalid single letter word
    When I make a GET request to the "Part Of" endpoint for the word "h"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not a part of anything

  Scenario: Numbers are not a part of anything
    When I make a GET request to the "Part Of" endpoint for the word "50"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not a part of anything

  Scenario: Ordinal numbers are not a part of anything
    When I make a GET request to the "Part Of" endpoint for the word "9th"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not a part of anything

  Scenario: Numbers as words
    When I make a GET request to the "Part Of" endpoint for the word "one"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not a part of anything

  Scenario Outline: Equivalent number and word not part of anything
    When I make a GET request to the "Part Of" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not a part of anything
    Examples:
      | word   |
      | 11     |
      | eleven |

  Scenario: Ordinal numbers and words can be part of different things
    When I make a GET request to the "Part Of" endpoint for the word "2nd"
    Then the word is not a part of anything
    When I make a GET request to the "Part Of" endpoint for the word "second"
    Then the word is a part of the following
      | minute             |
      | arcminute          |
      | minute of arc      |
      | min                |
      | automotive vehicle |
      | motor vehicle      |

  Scenario: Not all ordinal numbers as words are part of anything
    When I make a GET request to the "Part Of" endpoint for the word "fourth"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not a part of anything

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Part Of" endpoint for the phrase "steering wheel"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is a part of the following
      | steering mechanism |
      | steering system    |

  Scenario: Hyphenated words
    When I make a GET request to the "Part Of" endpoint for the word "splash-guard"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is a part of the following
      | bike       |
      | cycle      |
      | bicycle    |
      | motorcycle |
      | wheel      |

  Scenario: Words containing apostrophes
    When I make a GET request to the "Part Of" endpoint for the word "won't"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not a part of anything

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Part Of" endpoint for the word "wing"
    And I make a GET request to the "Part Of" endpoint for the word "wINg"
    And I make a GET request to the "Part Of" endpoint for the word "WING"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Part Of" endpoint for the word "yr"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is a part of the following
      | decade    |
      | decennium |
      | decennary |

  Scenario: Valid initialism
    When I make a GET request to the "Part Of" endpoint for the word "UK"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is a part of the following
      | british isles |

  Scenario: Popular brand name
    When I make a GET request to the "Part Of" endpoint for the word "pepsi"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not a part of anything

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "Part Of" endpoint for the phrase "terra firma"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is a part of the following
      | globe |
      | earth |
      | world |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Part Of" endpoint for the word "roof"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Part Of" endpoint for the word "roof"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Part Of" endpoint for the word "roof"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Part Of" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/partof does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |