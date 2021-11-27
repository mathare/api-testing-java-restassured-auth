#noinspection SpellCheckingInspection
Feature: "Has Instances" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Has Instances" endpoint for the word "physicist"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Has Instances" endpoint for the word "forest"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "forest"

  Scenario: Verify returned instances against data table
    When I make a GET request to the "Has Instances" endpoint for the word "felon"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following instances
      | bonney            |
      | william h. bonney |
      | rob roy           |
      | james             |
      | jesse james       |
      | macgregor         |
      | billie the kid    |
      | robert macgregor  |

  Scenario: Verify number of instances
    When I make a GET request to the "Has Instances" endpoint for the word "author"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 897 instances

  Scenario: Word has no instances
    When I make a GET request to the "Has Instances" endpoint for the word "fish"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no instances

  Scenario: Valid single letter word
    When I make a GET request to the "Has Instances" endpoint for the word "a"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no instances

  Scenario: Invalid single letter word
    When I make a GET request to the "Has Instances" endpoint for the word "e"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no instances

  Scenario: Numbers have no instances
    When I make a GET request to the "Has Instances" endpoint for the word "1"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no instances

  Scenario: Ordinal numbers have no instances
    When I make a GET request to the "Has Instances" endpoint for the word "2nd"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no instances

  Scenario: Numbers as words have no instances
    When I make a GET request to the "Has Instances" endpoint for the word "one"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no instances

  Scenario: Ordinal numbers as words have no instances
    When I make a GET request to the "Has Instances" endpoint for the word "second"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no instances

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Has Instances" endpoint for the phrase "search engine"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the phrase has the following instances
      | google     |
      | ask jeeves |
      | yahoo      |

  Scenario: Hyphenated words
    When I make a GET request to the "Has Instances" endpoint for the word "pre-raphaelite"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following instances
      | dante gabriel rossetti   |
      | holman hunt              |
      | hunt                     |
      | millais                  |
      | rossetti                 |
      | sir john everett millais |
      | william holman hunt      |

  Scenario: Words containing apostrophes
    When I make a GET request to the "Has Instances" endpoint for the word "we'd"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no instances

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Has Instances" endpoint for the word "murderer"
    And I make a GET request to the "Has Instances" endpoint for the word "mURdeREr"
    And I make a GET request to the "Has Instances" endpoint for the word "MURDERER"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Has Instances" endpoint for the word "doc"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 66 instances

  Scenario: Valid initialism
    When I make a GET request to the "Has Instances" endpoint for the word "GB"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following instances
      | albion |

  Scenario: Valid foreign word used in English
    When I make a GET request to the "Has Instances" endpoint for the word "bolshevik"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 12 instances

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Has Instances" endpoint for the word "ground"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Has Instances" endpoint for the word "ground"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Has Instances" endpoint for the word "ground"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Has Instances" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/hasinstances does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |