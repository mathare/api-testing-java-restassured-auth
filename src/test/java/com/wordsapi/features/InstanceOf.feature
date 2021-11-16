#noinspection CucumberTableInspection, SpellCheckingInspection
Feature: "Instance Of" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Instance Of" endpoint for the word "himalayas"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Instance Of" endpoint for the word "acre"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "acre"

  Scenario: Verify returned instances against data table
    When I make a GET request to the "Instance Of" endpoint for the word "leonardo"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is an instance of the following
      | applied scientist |
      | architect         |
      | carver            |
      | designer          |
      | engineer          |
      | old master        |
      | sculptor          |
      | sculpturer        |
      | statue maker      |
      | technologist      |

  Scenario: Word is not instance of anything
    When I make a GET request to the "Instance Of" endpoint for the word "swiftly"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an instance of anything

  Scenario: Valid single letter word
    When I make a GET request to the "Instance Of" endpoint for the word "a"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an instance of anything

  Scenario: Invalid single letter word
    When I make a GET request to the "Instance Of" endpoint for the word "u"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an instance of anything

  Scenario: Numbers are not an instance of anything
    When I make a GET request to the "Instance Of" endpoint for the word "2"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an instance of anything

  Scenario: Ordinal numbers are not an instance of anything
    When I make a GET request to the "Instance Of" endpoint for the word "3rd"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an instance of anything

  Scenario: Numbers as words are not an instance of anything
    When I make a GET request to the "Instance Of" endpoint for the word "nine"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an instance of anything

  Scenario: Ordinal numbers as words are not an instance of anything
    When I make a GET request to the "Instance Of" endpoint for the word "fourth"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an instance of anything

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Instance Of" endpoint for the phrase "middle ages"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is an instance of the following
      | historic period |
      | age             |

  Scenario: Hyphenated words
    When I make a GET request to the "Instance Of" endpoint for the word "commander-in-chief"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an instance of anything

  Scenario: Words containing apostrophes
    When I make a GET request to the "Instance Of" endpoint for the word "hadn't"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an instance of anything

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Instance Of" endpoint for the word "thames"
    And I make a GET request to the "Instance Of" endpoint for the word "tHaMeS"
    And I make a GET request to the "Instance Of" endpoint for the word "THAMES"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Instance Of" endpoint for the word "misc"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an instance of anything

  Scenario: Valid initialism
    When I make a GET request to the "Instance Of" endpoint for the word "WTC"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is an instance of the following
      | skyscraper |

  Scenario: Popular brand name
    When I make a GET request to the "Instance Of" endpoint for the word "yahoo"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is an instance of the following
      | search engine        |
      | character            |
      | fictional character  |
      | fictitious character |

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "Instance Of" endpoint for the phrase "al dente"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an instance of anything

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Instance Of" endpoint for the word "kitchen"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Instance Of" endpoint for the word "kitchen"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Instance Of" endpoint for the word "kitchen"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Instance Of" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/instanceof does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |