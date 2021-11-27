#noinspection SpellCheckingInspection
Feature: "Usage Of" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Usage Of" endpoint for the word "baloney"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Usage Of" endpoint for the word "posh"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "posh"

  Scenario: Verify returned values against data table
    When I make a GET request to the "Usage Of" endpoint for the word "juice"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is an example usage of the following
      | argot      |
      | cant       |
      | vernacular |
      | jargon     |
      | lingo      |
      | slang      |
      | patois     |

  Scenario: Word is not example usage of anything
    When I make a GET request to the "Usage Of" endpoint for the word "monkey"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an example usage of anything

  Scenario: Valid single letter word
    When I make a GET request to the "Usage Of" endpoint for the word "i"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an example usage of anything

  Scenario: Invalid single letter word
    When I make a GET request to the "Usage Of" endpoint for the word "p"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an example usage of anything

  Scenario: Numbers are not an example usage of anything
    When I make a GET request to the "Usage Of" endpoint for the word "25"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an example usage of anything

  Scenario: Ordinal numbers are not an example usage of anything
    When I make a GET request to the "Usage Of" endpoint for the word "10th"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an example usage of anything

  Scenario: Numbers as words
    When I make a GET request to the "Usage Of" endpoint for the word "six"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an example usage of anything

  Scenario: Ordinal numbers as words
    When I make a GET request to the "Usage Of" endpoint for the word "eleventh"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an example usage of anything

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Usage Of" endpoint for the phrase "home run"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the phrase is an example usage of the following
      | trope            |
      | figure of speech |
      | figure           |
      | image            |

  Scenario: Hyphenated words
    When I make a GET request to the "Usage Of" endpoint for the word "top-notch"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is an example usage of the following
      | colloquialism |

  Scenario: Words containing apostrophes
    When I make a GET request to the "Usage Of" endpoint for the word "shan't"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not an example usage of anything

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Usage Of" endpoint for the word "street"
    And I make a GET request to the "Usage Of" endpoint for the word "StReEt"
    And I make a GET request to the "Usage Of" endpoint for the word "STREET"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Usage Of" endpoint for the word "biz"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is an example usage of the following
      | colloquialism |

  Scenario: Valid initialism
    When I make a GET request to the "Usage Of" endpoint for the word "HQ"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is an example usage of the following
      | plural form |
      | plural      |

  Scenario: Popular brand name
    When I make a GET request to the "Usage Of" endpoint for the word "ipod"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is an example usage of the following
      | trademark |

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "Usage Of" endpoint for the phrase "fin de siecle"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the phrase is an example usage of the following
      | french |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Usage Of" endpoint for the word "garden"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Usage Of" endpoint for the word "garden"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Usage Of" endpoint for the word "garden"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Usage Of" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/usageof does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |