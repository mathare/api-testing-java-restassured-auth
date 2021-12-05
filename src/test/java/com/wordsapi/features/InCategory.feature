#noinspection SpellCheckingInspection
Feature: "In Category" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "In Category" endpoint for the word "spy"
    Then the response has a status code of 200
    And the response body follows the "InCategory" endpoint JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "In Category" endpoint for the word "transfiguration"
    Then the response has a status code of 200
    And the response body follows the "InCategory" endpoint JSON schema
    And the word field in the response body is "transfiguration"

  Scenario: Verify returned categories against data table
    When I make a GET request to the "In Category" endpoint for the word "instrument"
    Then the response has a status code of 200
    And the response body follows the "InCategory" endpoint JSON schema
    And the word is in the following categories
      | music         |
      | euphony       |
      | jurisprudence |
      | law           |

  Scenario: Verify number of categories
    When I make a GET request to the "In Category" endpoint for the word "politics"
    Then the response has a status code of 200
    And the response body follows the "InCategory" endpoint JSON schema
    And the word is in 6 categories

  Scenario: Word is in no categories
    When I make a GET request to the "In Category" endpoint for the word "green"
    Then the response has a status code of 200
    And the response body follows the "InCategory" endpoint JSON schema
    And the word is in no categories

  Scenario: Valid single letter word
    When I make a GET request to the "In Category" endpoint for the word "a"
    Then the response has a status code of 200
    And the response body follows the "InCategory" endpoint JSON schema
    And the word is in the following categories
      | biochemistry |

  Scenario: Invalid single letter word
    When I make a GET request to the "In Category" endpoint for the word "m"
    Then the response has a status code of 200
    And the response body follows the "InCategory" endpoint JSON schema
    And the word is in no categories

  Scenario: Numbers have no categories
    When I make a GET request to the "In Category" endpoint for the word "11"
    Then the response has a status code of 200
    And the response body follows the "InCategory" endpoint JSON schema
    And the word is in no categories

  Scenario: Ordinal numbers have no categories
    When I make a GET request to the "In Category" endpoint for the word "11th"
    Then the response has a status code of 200
    And the response body follows the "InCategory" endpoint JSON schema
    And the word is in no categories

  Scenario: Numbers as words have no categories
    When I make a GET request to the "In Category" endpoint for the word "seven"
    Then the response has a status code of 200
    And the response body follows the "InCategory" endpoint JSON schema
    And the word is in no categories

  Scenario: Ordinal numbers as words have no categories
    When I make a GET request to the "In Category" endpoint for the word "seventh"
    Then the response has a status code of 200
    And the response body follows the "InCategory" endpoint JSON schema
    And the word is in no categories

  Scenario: Valid multi-word phrase
    When I make a GET request to the "In Category" endpoint for the phrase "nuclear reactor"
    Then the response has a status code of 200
    And the response body follows the "InCategory" endpoint JSON schema
    And the phrase is in the following categories
      | physics            |
      | natural philosophy |

  Scenario: Hyphenated words
    When I make a GET request to the "In Category" endpoint for the word "black-and-white"
    Then the response has a status code of 200
    And the response body follows the "InCategory" endpoint JSON schema
    And the word is in the following categories
      | photography    |
      | picture taking |

  Scenario: Words containing apostrophes
    When I make a GET request to the "In Category" endpoint for the phrase "pitcher's mound"
    Then the response has a status code of 200
    And the response body follows the "InCategory" endpoint JSON schema
    And the phrase is in the following categories
      | ball          |
      | baseball      |
      | baseball game |

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "In Category" endpoint for the word "tube"
    And I make a GET request to the "In Category" endpoint for the word "tUBe"
    And I make a GET request to the "In Category" endpoint for the word "TUBE"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "In Category" endpoint for the word "ref"
    Then the response has a status code of 200
    And the response body follows the "InCategory" endpoint JSON schema
    And the word is in the following categories
      | athletics |
      | sport     |

  Scenario: Valid initialism
    When I make a GET request to the "In Category" endpoint for the word "BPM"
    Then the response has a status code of 200
    And the response body follows the "InCategory" endpoint JSON schema
    And the word is in the following categories
      | music |

  Scenario: Popular brand name
    When I make a GET request to the "In Category" endpoint for the word "disney"
    Then the response has a status code of 200
    And the response body follows the "InCategory" endpoint JSON schema
    And the word is in no categories

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "In Category" endpoint for the phrase "non sequitur"
    Then the response has a status code of 200
    And the response body follows the "InCategory" endpoint JSON schema
    And the phrase is in the following categories
      | logic |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "In Category" endpoint for the word "voice"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "In Category" endpoint for the word "voice"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "In Category" endpoint for the word "voice"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "In Category" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/incategory does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |