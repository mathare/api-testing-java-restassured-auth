#noinspection SpellCheckingInspection
Feature: "Syllables" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Syllables" endpoint for the word "anthropomorphically"
    Then the response has a status code of 200
    And the response body follows the "Syllables" endpoint JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Syllables" endpoint for the word "straddle"
    Then the response has a status code of 200
    And the response body follows the "Syllables" endpoint JSON schema
    And the word field in the response body is "straddle"

  Scenario: Verify returned syllables against data table
    When I make a GET request to the "Syllables" endpoint for the word "electroencephalographically"
    Then the response has a status code of 200
    And the response body follows the "Syllables" endpoint JSON schema
    And the word has the following syllables
      | e     |
      | lec   |
      | tro   |
      | en    |
      | ceph  |
      | a     |
      | lo    |
      | graph |
      | i     |
      | cal   |
      | ly    |

  Scenario: Valid single letter word
    When I make a GET request to the "Syllables" endpoint for the word "i"
    Then the response has a status code of 200
    And the response body follows the "Syllables" endpoint JSON schema
    And the word has no syllables

  Scenario: Invalid single letter word
    When I make a GET request to the "Syllables" endpoint for the word "f"
    Then the response has a status code of 200
    And the response body follows the "Syllables" endpoint JSON schema
    And the word has no syllables

  Scenario: Numbers have no syllables
    When I make a GET request to the "Syllables" endpoint for the word "10"
    Then the response has a status code of 200
    And the response body follows the "Syllables" endpoint JSON schema
    And the word has no syllables

  Scenario: Ordinal numbers have no syllables
    When I make a GET request to the "Syllables" endpoint for the word "10th"
    Then the response has a status code of 200
    And the response body follows the "Syllables" endpoint JSON schema
    And the word has no syllables

  Scenario: Numbers as words
    When I make a GET request to the "Syllables" endpoint for the word "seventeen"
    Then the response has a status code of 200
    And the response body follows the "Syllables" endpoint JSON schema
    And the word has 3 syllables

  Scenario: Ordinal numbers as words
    When I make a GET request to the "Syllables" endpoint for the word "first"
    Then the response has a status code of 200
    And the response body follows the "Syllables" endpoint JSON schema
    And the word has 1 syllable

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Syllables" endpoint for the phrase "proportional representation"
    Then the response has a status code of 200
    And the response body follows the "Syllables" endpoint JSON schema
    And the phrase has 8 syllables

  Scenario: Hyphenated words
    # I think this is wrong & the word has 5 syllables but the API response has 4
    When I make a GET request to the "Syllables" endpoint for the word "three-dimensional"
    Then the response has a status code of 200
    And the response body follows the "Syllables" endpoint JSON schema
    And the word has 4 syllables

  Scenario: Words containing apostrophes
    When I make a GET request to the "Syllables" endpoint for the word "aren't"
    Then the response has a status code of 200
    And the response body follows the "Syllables" endpoint JSON schema
    And the word has 1 syllable

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Syllables" endpoint for the word "proletariat"
    And I make a GET request to the "Syllables" endpoint for the word "PrOlEtArIaT"
    And I make a GET request to the "Syllables" endpoint for the word "PROLETARIAT"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Syllables" endpoint for the word "misc"
    Then the response has a status code of 200
    And the response body follows the "Syllables" endpoint JSON schema
    And the word has 1 syllable

  Scenario: Valid initialism
    When I make a GET request to the "Syllables" endpoint for the word "DJ"
    Then the response has a status code of 200
    And the response body follows the "Syllables" endpoint JSON schema
    And the word has 2 syllables

  Scenario: Popular brand name
    When I make a GET request to the "Syllables" endpoint for the word "chanel"
    Then the response has a status code of 200
    And the response body follows the "Syllables" endpoint JSON schema
    And the word has the following syllables
      | Cha |
      | nel |

  Scenario: Valid foreign word used in English
    When I make a GET request to the "Syllables" endpoint for the word "blitzkrieg"
    Then the response has a status code of 200
    And the response body follows the "Syllables" endpoint JSON schema
    And the word has 2 syllables

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Syllables" endpoint for the word "plaster"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Syllables" endpoint for the word "plaster"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Syllables" endpoint for the word "plaster"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Syllables" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/syllables does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |