#noinspection SpellCheckingInspection
Feature: "Frequency" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Frequency" endpoint for the word "rare"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Frequency" endpoint for the word "tropical"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "tropical"

  Scenario: Verify returned frequency values against data table
    When I make a GET request to the "Frequency" endpoint for the word "dull"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following frequency values
      | zipf       | 3.99 |
      | perMillion | 9.81 |
      | diversity  | 0.05 |

  Scenario: Verify individual frequency values
    When I make a GET request to the "Frequency" endpoint for the word "mineral"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has a "zipf" frequency value of 3.56
    And the word has a "perMillion" frequency value of 3.61
    And the word has a "diversity" frequency value of 0.02

  Scenario: Diversity frequency value is 0
    When I make a GET request to the "Frequency" endpoint for the word "intestinal"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has a "zipf" frequency value of 2.66
    And the word has a "perMillion" frequency value of 0.44
    And the word has a "diversity" frequency value of 0

  Scenario: Word has no frequency values
    When I make a GET request to the "Type Of" endpoint for the word "parallelogram"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no frequency values

  Scenario: Valid single letter word
    When I make a GET request to the "Frequency" endpoint for the word "i"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has a "zipf" frequency value of 7.56
    And the word has a "perMillion" frequency value of 36210.22
    And the word has a "diversity" frequency value of 1

  Scenario: Invalid single letter word
    When I make a GET request to the "Frequency" endpoint for the word "t"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no frequency values

  Scenario: Get frequency of number instead of word
    When I make a GET request to the "Frequency" endpoint for the word "6"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no frequency values

  Scenario: Frequency of ordinal numbersg
    When I make a GET request to the "Frequency" endpoint for the word "10th"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has a "zipf" frequency value of 3.76
    And the word has a "perMillion" frequency value of 5.77
    And the word has a "diversity" frequency value of 0.02

  Scenario: Numbers as words
    When I make a GET request to the "Frequency" endpoint for the word "eight"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has a "zipf" frequency value of 4.95
    And the word has a "perMillion" frequency value of 88.74
    And the word has a "diversity" frequency value of 0.28

  Scenario: Equivalent numbers and words have different frequency values
    When I make a GET request to the "Frequency" endpoint for the word "4"
    Then the word has no frequency values
    When I make a GET request to the "Frequency" endpoint for the word "four"
    Then the word has a "zipf" frequency value of 5.37
    And the word has a "perMillion" frequency value of 232.95
    And the word has a "diversity" frequency value of 0.52

  Scenario: Ordinal numbers and words have different frequencies
    When I make a GET request to the "Frequency" endpoint for the word "5th"
    And the word has a "zipf" frequency value of 3.82
    And the word has a "perMillion" frequency value of 6.57
    And the word has a "diversity" frequency value of 0.03
    When I make a GET request to the "Frequency" endpoint for the word "fifth"
    And the word has a "zipf" frequency value of 4.21
    And the word has a "perMillion" frequency value of 16.02
    And the word has a "diversity" frequency value of 0.07

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Frequency" endpoint for the phrase "radio beam"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the phrase has no frequency values

  Scenario: Hyphenated words
    When I make a GET request to the "Frequency" endpoint for the word "right-handed"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no frequency values

  Scenario: Words containing apostrophes
    When I make a GET request to the "Frequency" endpoint for the word "hasn't"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has a "zipf" frequency value of 4.92
    And the word has a "perMillion" frequency value of 83.93
    And the word has a "diversity" frequency value of 0.33

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Frequency" endpoint for the word "financial"
    And I make a GET request to the "Frequency" endpoint for the word "FiNaNcIaL"
    And I make a GET request to the "Frequency" endpoint for the word "FINANCIAL"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Frequency" endpoint for the word "lite"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has a "zipf" frequency value of 2.7
    And the word has a "perMillion" frequency value of 0.49
    And the word has a "diversity" frequency value of 0

  Scenario: Valid initialism
    When I make a GET request to the "Frequency" endpoint for the word "CEO"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has a "zipf" frequency value of 3.74
    And the word has a "perMillion" frequency value of 5.48
    And the word has a "diversity" frequency value of 0.02

  Scenario: Popular brand name
    When I make a GET request to the "Frequency" endpoint for the word "nike"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has a "zipf" frequency value of 3.25
    And the word has a "perMillion" frequency value of 1.76
    And the word has a "diversity" frequency value of 0

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "Frequency" endpoint for the phrase "per capita"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the phrase has no frequency values

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Frequency" endpoint for the word "kitchen"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Frequency" endpoint for the word "kitchen"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Frequency" endpoint for the word "kitchen"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Frequency" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/frequency does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |