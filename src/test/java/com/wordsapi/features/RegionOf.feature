#noinspection CucumberTableInspection, SpellCheckingInspection
Feature: "Region Of" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Region Of" endpoint for the word "england"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Region Of" endpoint for the word "peru"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "peru"

  Scenario: Verify returned regional words against data table
    When I make a GET request to the "Region Of" endpoint for the word "hawaii"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the following words are used in this region
      | macadamia nut        |
      | macadamia ternifolia |
      | mahimahi             |
      | dolphinfish          |
      | ukulele              |
      | lanai                |
      | luau                 |
      | macadamia nut tree   |
      | hawaiian             |
      | uke                  |
      | dolphin              |
      | malahini             |

  Scenario: No regional words
    When I make a GET request to the "Region Of" endpoint for the word "london"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And no words are specific to this region

  # There are no scenarios for single letter words, numbers - as digits or words - and ordinal numbers because the
  # "Region Of" endpoint makes no sense for such words. It is used to return the words specific to that region so the
  # word parameter should be some form of geographical place, e.g. a country

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Region Of" endpoint for the phrase "south africa"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the following words are used in this region
      | qibla                                |
      | koppie                               |
      | kaffir                               |
      | biltong                              |
      | laager                               |
      | lager                                |
      | people against gangsterism and drugs |
      | kopje                                |
      | mealie                               |
      | trek                                 |
      | kafir                                |
      | caffer                               |
      | caffre                               |
      | pagad                                |

  Scenario: Hyphenated words
    When I make a GET request to the "Region Of" endpoint for the word "dae-han-min-gook"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the following words are used in this region
      | korean war         |
      | chino-japanese war |
      | sino-japanese war  |

  Scenario: Words containing punctuation
    When I make a GET request to the "Region Of" endpoint for the word "u.s."
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And 120 words are specific to this region

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Region Of" endpoint for the word "canada"
    And I make a GET request to the "Region Of" endpoint for the word "caNAda"
    And I make a GET request to the "Region Of" endpoint for the word "CANADA"
    Then all response bodies are identical

  Scenario: Valid initialism
    When I make a GET request to the "Region Of" endpoint for the word "UK"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And 675 words are specific to this region

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Region Of" endpoint for the word "africa"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Region Of" endpoint for the word "africa"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Region Of" endpoint for the word "africa"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Region Of" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/regionof does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |