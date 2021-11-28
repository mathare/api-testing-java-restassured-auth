#noinspection SpellCheckingInspection, NonAsciiCharacters
Feature: "Pronunciation" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Pronunciation" endpoint for the word "wind"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Pronunciation" endpoint for the word "giraffe"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "giraffe"

  Scenario: Verify single pronunciation
    When I make a GET request to the "Pronunciation" endpoint for the word "regular"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is pronounced "'rɛɡjələr"

  Scenario: Word has no pronunciation
    When I make a GET request to the "Pronunciation" endpoint for the word "demount"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no pronunciation specified

  Scenario: Different pronunciations for different forms of word
    When I make a GET request to the "Pronunciation" endpoint for the word "deliberate"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is pronounced "dɪ'lɪbɜrət"
    And the adjective form of the word is pronounced "dɪ'lɪbərɪt"
    And the verb form of the word is pronounced "dɪ'lɪbə,reɪt"

  Scenario Outline: Silent letters at the start of words - <word>
    When I make a GET request to the "Pronunciation" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is pronounced "<pronunciation>"
    Examples:
      | word      | pronunciation |
      | pneumatic | nʊ'mætɪk      |
      | gnome     | noʊm          |
      | knight    | naɪt          |

  Scenario Outline: Similar spellings can have different pronunciations - <word>
    When I make a GET request to the "Pronunciation" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is pronounced "<pronunciation>"
    Examples:
      | word    | pronunciation |
      | rough   | rəf           |
      | cough   | kɔf           |
      | bough   | baʊ           |
      | dough   | doʊ           |
      | through | θru           |

  Scenario Outline: Pluralisation can lead to different pronunciation - <word>
    When I make a GET request to the "Pronunciation" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is pronounced "<pronunciation>"
    Examples:
      | word  | pronunciation |
      | woman | 'wʊmən        |
      | women | 'wɪmʌn        |

  Scenario Outline: Different words can have the same pronunciation - <word>
    When I make a GET request to the "Pronunciation" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is pronounced "<pronunciation>"
    Examples:
      | word  | pronunciation |
      | rain  | reɪn          |
      | rein  | reɪn          |
      | reign | reɪn          |

  Scenario: Valid single letter word
    When I make a GET request to the "Pronunciation" endpoint for the word "a"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is pronounced "eɪ"

  Scenario: Invalid single letter word
    When I make a GET request to the "Pronunciation" endpoint for the word "j"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is pronounced "dʒeɪ"

  Scenario: Numbers have no pronunciation
    When I make a GET request to the "Pronunciation" endpoint for the word "55"
    Then the response has a status code of 200
    And the word has no pronunciation specified

  Scenario: Ordinal numbers have no pronunciatiom
    When I make a GET request to the "Pronunciation" endpoint for the word "21st"
    Then the response has a status code of 200
    And the word has no pronunciation specified

  Scenario: Numbers as words
    When I make a GET request to the "Pronunciation" endpoint for the word "forty"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is pronounced "'fɔrti"

  Scenario: Ordinal numbers as words
    When I make a GET request to the "Pronunciation" endpoint for the word "third"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is pronounced "θɜrd"

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Pronunciation" endpoint for the phrase "supernatural being"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the phrase is pronounced ",supər'næʧərəl_'biɪŋ"

  Scenario: Hyphenated words
    When I make a GET request to the "Pronunciation" endpoint for the word "hard-and-fast"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is pronounced "'hɑrdən_'fæst"

  Scenario: Words containing apostrophes
    When I make a GET request to the "Pronunciation" endpoint for the word "haven't"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is pronounced "'hævʌnt"

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Pronunciation" endpoint for the word "mobile"
    And I make a GET request to the "Pronunciation" endpoint for the word "MoBiLe"
    And I make a GET request to the "Pronunciation" endpoint for the word "MOBILE"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Pronunciation" endpoint for the word "min"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is pronounced "mɪn"

  Scenario: Valid initialism
    When I make a GET request to the "Pronunciation" endpoint for the word "CEO"
    Then the response has a status code of 200
    And the word has no pronunciation specified

  Scenario: Popular brand name
    When I make a GET request to the "Pronunciation" endpoint for the word "nike"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is pronounced "'naɪki"

  Scenario: Valid foreign word used in English
    When I make a GET request to the "Pronunciation" endpoint for the word "doppelganger"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is pronounced "'dɑpəl,ɡæŋər"

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Pronunciation" endpoint for the word "carpet"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Pronunciation" endpoint for the word "carpet"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Pronunciation" endpoint for the word "carpet"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Pronunciation" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/pronunciation does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |