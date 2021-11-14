#noinspection SpellCheckingInspection
Feature: "Rhymes" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Rhymes" endpoint for the word "truck"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Rhymes" endpoint for the word "dog"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "dog"

  Scenario: Verify returned rhymes against data table
    When I make a GET request to the "Rhymes" endpoint for the word "lamp"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following rhymes
      | abamp        |
      | afterdamp    |
      | amp          |
      | blackdamp    |
      | camp         |
      | champ        |
      | chokedamp    |
      | clamp        |
      | aide-de-camp |
      | cramp        |
      | damp         |
      | decamp       |
      | encamp       |
      | firedamp     |
      | gamp         |
      | lamp         |
      | ramp         |
      | revamp       |
      | scamp        |
      | stamp        |
      | tamp         |
      | tramp        |
      | vamp         |

  Scenario: Word has no rhymes
    When I make a GET request to the "Rhymes" endpoint for the word "overcomplicate"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no rhymes

  Scenario: Different rhymes for verb & noun forms of word
    When I make a GET request to the "Rhymes" endpoint for the word "house"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the noun form of the word has 78 rhymes
    And the verb form of the word has 8 rhymes

  Scenario: Valid single letter word
    When I make a GET request to the "Rhymes" endpoint for the word "i"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 345 rhymes

  Scenario: Invalid single letter word
    When I make a GET request to the "Rhymes" endpoint for the word "f"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 12 rhymes

  Scenario: Numbers have no rhymes
    When I make a GET request to the "Rhymes" endpoint for the word "9"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no rhymes

  Scenario: Ordinal numbers have no numbers
    When I make a GET request to the "Rhymes" endpoint for the word "3rd"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no rhymes

  Scenario: Numbers as words
    When I make a GET request to the "Rhymes" endpoint for the word "five"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 35 rhymes

  Scenario: Equivalent numbers & words have different rhymes
    When I make a GET request to the "Rhymes" endpoint for the word "2"
    Then the word has no rhymes
    When I make a GET request to the "Rhymes" endpoint for the word "two"
    Then the word has 274 rhymes

  Scenario: Ordinal numbers and words have different rhymes
    When I make a GET request to the "Rhymes" endpoint for the word "2nd"
    Then the word has no rhymes
    When I make a GET request to the "Rhymes" endpoint for the word "second"
    Then the word has 14 rhymes

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Rhymes" endpoint for the phrase "burning ember"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 22 rhymes

  Scenario: Hyphenated words
    When I make a GET request to the "Rhymes" endpoint for the word "long-lasting"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 22 rhymes

  Scenario: Words containing apostrophes
    When I make a GET request to the "Rhymes" endpoint for the word "should've"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no rhymes

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Rhymes" endpoint for the word "phone"
    And I make a GET request to the "Rhymes" endpoint for the word "pHoNe"
    And I make a GET request to the "Rhymes" endpoint for the word "PHONE"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Rhymes" endpoint for the word "max"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 28 rhymes

  Scenario: Valid initialism
    When I make a GET request to the "Rhymes" endpoint for the word "TV"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 416 rhymes

  Scenario: Popular brand name
    When I make a GET request to the "Rhymes" endpoint for the word "microsoft"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no rhymes

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "Rhymes" endpoint for the phrase "compos mentis"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 5 rhymes

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Rhymes" endpoint for the word "painting"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Rhymes" endpoint for the word "painting"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Rhymes" endpoint for the word "painting"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Rhymes" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/rhymes does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |