#noinspection SpellCheckingInspection
Feature: "Substance Of" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Substance Of" endpoint for the word "aniseed"
    Then the response has a status code of 200
    And the response body follows the "SubstanceOf" endpoint JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Substance Of" endpoint for the word "flour"
    Then the response has a status code of 200
    And the response body follows the "SubstanceOf" endpoint JSON schema
    And the word field in the response body is "flour"

  Scenario: Verify returned values against data table
    When I make a GET request to the "Substance Of" endpoint for the word "rum"
    Then the response has a status code of 200
    And the response body follows the "SubstanceOf" endpoint JSON schema
    And the word is a substance of the following
      | planter's punch |
      | daiquiri        |
      | swizzle         |
      | toddy           |
      | tom and jerry   |
      | zombi           |
      | zombie          |
      | hot toddy       |
      | rum cocktail    |

  Scenario: Word is not substance of anything
    When I make a GET request to the "Substance Of" endpoint for the word "quickly"
    Then the response has a status code of 200
    And the response body follows the "SubstanceOf" endpoint JSON schema
    And the word is not a substance of anything

  Scenario: Valid single letter word
    When I make a GET request to the "Substance Of" endpoint for the word "i"
    Then the response has a status code of 200
    And the response body follows the "SubstanceOf" endpoint JSON schema
    And the word is a substance of the following
      | saltwater |
      | brine     |
      | seawater  |

  Scenario: Invalid single letter word
    When I make a GET request to the "Substance Of" endpoint for the word "g"
    Then the response has a status code of 200
    And the response body follows the "SubstanceOf" endpoint JSON schema
    And the word is a substance of the following
      | deoxyribonucleic acid  |
      | desoxyribonucleic acid |
      | rna                    |
      | dna                    |
      | ribonucleic acid       |

  Scenario: Numbers are not a substance of anything
    When I make a GET request to the "Substance Of" endpoint for the word "1"
    Then the response has a status code of 200
    And the response body follows the "SubstanceOf" endpoint JSON schema
    And the word is not a substance of anything

  Scenario: Ordinal numbers are not a substance of anything
    When I make a GET request to the "Substance Of" endpoint for the word "1st"
    Then the response has a status code of 200
    And the response body follows the "SubstanceOf" endpoint JSON schema
    And the word is not a substance of anything

  Scenario: Numbers as words are not a substance of anything
    When I make a GET request to the "Substance Of" endpoint for the word "five"
    Then the response has a status code of 200
    And the response body follows the "SubstanceOf" endpoint JSON schema
    And the word is not a substance of anything

  Scenario: Ordinal umbers as words are not a substance of anything
    When I make a GET request to the "Substance Of" endpoint for the word "fifth"
    Then the response has a status code of 200
    And the response body follows the "SubstanceOf" endpoint JSON schema
    And the word is not a substance of anything

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Substance Of" endpoint for the phrase "potassium nitrate"
    Then the response has a status code of 200
    And the response body follows the "SubstanceOf" endpoint JSON schema
    And the phrase is a substance of the following
      | fertiliser |
      | fertilizer |
      | plant food |

  Scenario: Hyphenated words
    When I make a GET request to the "Substance Of" endpoint for the word "lipo-lutin"
    Then the response has a status code of 200
    And the response body follows the "SubstanceOf" endpoint JSON schema
    And the word is a substance of 7 things

  Scenario: Words containing apostrophes
    When I make a GET request to the "Substance Of" endpoint for the word "couldn't"
    Then the response has a status code of 200
    And the response body follows the "SubstanceOf" endpoint JSON schema
    And the word is not a substance of anything

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Substance Of" endpoint for the word "ethanol"
    And I make a GET request to the "Substance Of" endpoint for the word "eThAnOl"
    And I make a GET request to the "Substance Of" endpoint for the word "ETHANOL"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Substance Of" endpoint for the word "h2o"
    Then the response has a status code of 200
    And the response body follows the "SubstanceOf" endpoint JSON schema
    And the word is a substance of 18 things

  Scenario: Valid initialism
    When I make a GET request to the "Substance Of" endpoint for the word "EU"
    Then the response has a status code of 200
    And the response body follows the "SubstanceOf" endpoint JSON schema
    And the word is a substance of the following
      | monazite |

  Scenario: Popular brand name
    When I make a GET request to the "Substance Of" endpoint for the word "saran"
    Then the response has a status code of 200
    And the response body follows the "SubstanceOf" endpoint JSON schema
    And the word is a substance of the following
      | cling film |
      | clingfilm  |
      | saran wrap |

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "Substance Of" endpoint for the phrase "dura mater"
    Then the response has a status code of 200
    And the response body follows the "SubstanceOf" endpoint JSON schema
    And the phrase is a substance of the following
      | tentorium |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Substance Of" endpoint for the word "sand"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Substance Of" endpoint for the word "sand"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Substance Of" endpoint for the word "sand"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Substance Of" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/substanceof does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |