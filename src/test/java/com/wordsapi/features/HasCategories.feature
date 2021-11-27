#noinspection SpellCheckingInspection
Feature: "Has Categories" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Has Categories" endpoint for the word "operation"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Has Categories" endpoint for the word "legend"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "legend"

  Scenario: Verify returned categories against data table
    When I make a GET request to the "Has Categories" endpoint for the word "science"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following categories
      | theorizer    |
      | verify       |
      | theorist     |
      | idealogue    |
      | theoretician |
      | control      |
      | theoriser    |
      | maths        |
      | mathematics  |
      | math         |

  Scenario: Verify number of categories
    When I make a GET request to the "Has Categories" endpoint for the word "religion"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 88 categories

  Scenario: Word has no categories
    When I make a GET request to the "Has Categories" endpoint for the word "bookcase"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no categories

  Scenario: Valid single letter word
    When I make a GET request to the "Has Categories" endpoint for the word "i"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no categories

  Scenario: Invalid single letter word
    When I make a GET request to the "Has Categories" endpoint for the word "c"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no categories

  Scenario: Numbers have no categories
    When I make a GET request to the "Has Categories" endpoint for the word "1"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no categories

  Scenario: Ordinal numbers have no categories
    When I make a GET request to the "Has Categories" endpoint for the word "1st"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no categories

  Scenario: Numbers as words have no categories
    When I make a GET request to the "Has Categories" endpoint for the word "one"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no categories

  Scenario: Ordinal numbers as words have no categories
    When I make a GET request to the "Has Categories" endpoint for the word "first"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no categories

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Has Categories" endpoint for the phrase "auction sale"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the phrase has the following categories
      | underbid    |
      | upset price |
      | bid         |
      | by-bid      |
      | offer       |
      | outbid      |
      | overbid     |
      | tender      |

  Scenario: Hyphenated words
    When I make a GET request to the "Has Categories" endpoint for the word "law-breaking"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 47 categories

  Scenario: Words containing apostrophes
    When I make a GET request to the "Has Categories" endpoint for the word "rock'n'roll"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following categories
      | backbeat |

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Has Categories" endpoint for the word "poetry"
    And I make a GET request to the "Has Categories" endpoint for the word "PoEtRy"
    And I make a GET request to the "Has Categories" endpoint for the word "POETRY"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Has Categories" endpoint for the word "pic"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following categories
      | tape        |
      | dub         |
      | videotape   |
      | film        |
      | take        |
      | synchronize |
      | synchronise |
      | shoot       |
      | reshoot     |

  Scenario: Valid initialism
    When I make a GET request to the "Has Categories" endpoint for the word "TV"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 19 categories

  Scenario: Popular brand name
    When I make a GET request to the "Has Categories" endpoint for the word "amazon"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no categories

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "Has Categories" endpoint for the phrase "jus civile"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the phrase has the following categories
      | addiction |
      | novate    |
      | stipulate |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Has Categories" endpoint for the word "galley"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Has Categories" endpoint for the word "galley"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Has Categories" endpoint for the word "galley"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Has Categories" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/hascategories does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |