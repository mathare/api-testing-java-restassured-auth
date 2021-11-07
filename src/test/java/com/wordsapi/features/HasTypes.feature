#noinspection SpellCheckingInspection
Feature: "Has Types" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Has Types" endpoint for the word "vehicle"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Has Types" endpoint for the word "furniture"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "furniture"

  Scenario: Verify returned types against data table
    When I make a GET request to the "Has Types" endpoint for the word "shelf"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following types
      | berm         |
      | mantelpiece  |
      | mantle       |
      | mantlepiece  |
      | chimneypiece |
      | overmantel   |
      | bookshelf    |
      | hob          |
      | mantel       |

  Scenario: Word has no types
    When I make a GET request to the "Has Types" endpoint for the word "eaten"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no types

  Scenario: Valid single letter word
    When I make a GET request to the "Has Types" endpoint for the word "i"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following types
      | iodine-125 |
      | iodine-131 |
      | monas      |
      | singleton  |
      | monad      |

  Scenario: Invalid single letter word
    When I make a GET request to the "Has Types" endpoint for the word "x"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no types

  Scenario Outline: Get number of types for number - <number>
    When I make a GET request to the "Has Types" endpoint for the word "<number>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has <types> types
    Examples:
      | number | types |
      | 1      | 3     |
      | 2      | 15    |
      | 3      | 0     |
      | 10     | 0     |
      | 100    | 0     |

  Scenario: Order of types not necessarily the same for equivalent numbers & words
    When I make a GET request to the "Has Types" endpoint for the word "1"
    Then the word has the following types
      | monad     |
      | monas     |
      | singleton |
    When I make a GET request to the "Has Types" endpoint for the word "one"
    Then the word has the following types
      | monad     |
      | singleton |
      | monas     |

  Scenario: Ordinal numbers have no types
    When I make a GET request to the "Has Types" endpoint for the word "2nd"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no types

  Scenario: Ordinal numbers and words can have different types
    When I make a GET request to the "Has Types" endpoint for the word "1st"
    Then the word has no types
    When I make a GET request to the "Has Types" endpoint for the word "first"
    Then the word has the following types
      | threshold      |
      | incipiency     |
      | starting point |
      | birth          |
      | incipience     |
      | terminus a quo |
      | former         |
      | double first   |

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Has Types" endpoint for the phrase "record player"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following types
      | acoustic gramophone |
      | gramophone          |
      | jukebox             |
      | nickelodeon         |

  Scenario: Hyphenated words
    When I make a GET request to the "Has Types" endpoint for the word "relative-in-law"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following types
      | father-in-law   |
      | mother-in-law   |
      | sister-in-law   |
      | brother-in-law  |
      | son-in-law      |
      | daughter-in-law |

  Scenario: Words containing apostrophes
    When I make a GET request to the "Has Types" endpoint for the word "can't"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no types

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Has Types" endpoint for the word "book"
    And I make a GET request to the "Has Types" endpoint for the word "bOOk"
    And I make a GET request to the "Has Types" endpoint for the word "BOOK"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Has Types" endpoint for the word "pro"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following types
      | semipro          |
      | semiprofessional |
      | free agent       |

  Scenario: Valid initialism
    When I make a GET request to the "Has Types" endpoint for the word "TV"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following types
      | cable                      |
      | high-definition television |
      | cable television           |
      | hdtv                       |

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "Has Types" endpoint for the phrase "persona non grata"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 30 types

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Has Types" endpoint for the phrase "wall"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Has Types" endpoint for the phrase "wall"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Has Types" endpoint for the phrase "wall"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Has Types" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/hastypes does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |