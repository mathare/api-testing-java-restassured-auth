#noinspection SpellCheckingInspection
Feature: "Member Of" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Member Of" endpoint for the word "queen"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Member Of" endpoint for the word "cedar"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "cedar"

  Scenario: Verify returned values against data table
    When I make a GET request to the "Member Of" endpoint for the word "worker"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is a member of the following
      | proletariat   |
      | labor         |
      | labour        |
      | working class |

  Scenario: Word is not member of anything
    When I make a GET request to the "Member Of" endpoint for the word "vase"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not a member of anything

  Scenario: Valid single letter word
    When I make a GET request to the "Member Of" endpoint for the word "a"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is a member of the following
      | latin alphabet |
      | roman alphabet |

  Scenario: Invalid single letter word
    When I make a GET request to the "Member Of" endpoint for the word "g"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is a member of the following
      | roman alphabet |
      | latin alphabet |

  Scenario: Numbers are not a member of anything
    When I make a GET request to the "Member Of" endpoint for the word "1"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not a member of anything

  Scenario: Ordinal numbers are not a member of anything
    When I make a GET request to the "Member Of" endpoint for the word "1st"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not a member of anything

  Scenario: Numbers as words
    When I make a GET request to the "Member Of" endpoint for the word "seven"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not a member of anything

  Scenario Outline: Some ordinal numbers as words are members
    When I make a GET request to the "Member Of" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is a member of the following
      | baseball team |
    Examples:
      | word   |
      | first  |
      | second |
      | third  |

  Scenario Outline: Other ordinal numbers as words are not members of anything
    When I make a GET request to the "Member Of" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not a member of anything
    Examples:
      | word    |
      | fourth  |
      | fifth   |
      | sixth   |
      | seventh |
      | eighth  |
      | ninth   |

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Member Of" endpoint for the phrase "oak tree"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the phrase is a member of the following
      | genus quercus |
      | quercus       |

  Scenario: Hyphenated words
    When I make a GET request to the "Member Of" endpoint for the word "orb-weaver"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is a member of the following
      | araneida       |
      | order araneida |
      | order araneae  |
      | araneae        |

  Scenario: Words containing apostrophes
    When I make a GET request to the "Member Of" endpoint for the word "shi'ite"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is a member of the following
      | shia        |
      | shiah       |
      | shiah islam |

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Member Of" endpoint for the word "elephant"
    And I make a GET request to the "Member Of" endpoint for the word "eLEphANt"
    And I make a GET request to the "Member Of" endpoint for the word "ELEPHANT"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Member Of" endpoint for the word "fan"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is a member of the following
      | following |
      | followers |

  Scenario: Valid initialism
    When I make a GET request to the "Member Of" endpoint for the word "NSA"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is a member of the following
      | united states intelligence community |
      | ic                                   |
      | intelligence community               |
      | national intelligence community      |

  Scenario: Popular brand name
    When I make a GET request to the "Member Of" endpoint for the word "ford"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is not a member of anything

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "Member Of" endpoint for the phrase "genus homo"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the phrase is a member of the following
      | hominidae        |
      | family hominidae |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Member Of" endpoint for the word "feather"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Member Of" endpoint for the word "feather"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Member Of" endpoint for the word "feather"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Member Of" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/memberof does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |