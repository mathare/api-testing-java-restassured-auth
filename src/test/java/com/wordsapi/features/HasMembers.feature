#noinspection SpellCheckingInspection
Feature: "Has Members" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Has Members" endpoint for the word "train"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Has Members" endpoint for the word "family"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "family"

  Scenario: Verify returned members against data table
    When I make a GET request to the "Has Members" endpoint for the word "people"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following members
      | citizen    |
      | mortal     |
      | individual |
      | person     |
      | somebody   |
      | someone    |
      | soul       |

  Scenario: Word has no members
    When I make a GET request to the "Has Members" endpoint for the word "superlative"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no members

  Scenario: Valid single letter word
    When I make a GET request to the "Has Members" endpoint for the word "i"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no members

  Scenario: Invalid single letter word
    When I make a GET request to the "Has Members" endpoint for the word "h"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no members

  Scenario: Numbers have no members
    When I make a GET request to the "Has Members" endpoint for the word "1"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no members

  Scenario: Ordinal numbers have no members
    When I make a GET request to the "Has Members" endpoint for the word "5th"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no members

  Scenario: Numbers as words have no members
    When I make a GET request to the "Has Members" endpoint for the word "one"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no members

  Scenario: Ordinal numbers as words have no members
    When I make a GET request to the "Has Members" endpoint for the word "fifth"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no members

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Has Members" endpoint for the phrase "cactus family"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 53 members

  Scenario: Hyphenated words
    When I make a GET request to the "Has Members" endpoint for the word "kwazulu-natal"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following members
      | zulu |

  Scenario: Words containing apostrophes
    When I make a GET request to the "Has Members" endpoint for the word "won't"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no members

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Has Members" endpoint for the word "fleet"
    And I make a GET request to the "Has Members" endpoint for the word "FlEeT"
    And I make a GET request to the "Has Members" endpoint for the word "FLEET"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Has Members" endpoint for the word "fed"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following members
      | reserve bank         |
      | federal reserve bank |
      | member bank          |
      | national bank        |

  Scenario: Valid initialism
    When I make a GET request to the "Has Members" endpoint for the word "EU"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 50 members

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "Has Members" endpoint for the phrase "genus falco"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following members
      | falco columbarius |
      | falco peregrinus  |
      | falco rusticolus  |
      | falco sparverius  |
      | falco subbuteo    |
      | falco tinnunculus |
      | sparrow hawk      |
      | pigeon hawk       |
      | american kestrel  |
      | gerfalcon         |
      | gyrfalcon         |
      | hobby             |
      | kestrel           |
      | merlin            |
      | peregrine         |
      | peregrine falcon  |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Has Members" endpoint for the word "royalty"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Has Members" endpoint for the word "royalty"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Has Members" endpoint for the word "royalty"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Has Members" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/hasmembers does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |