#noinspection SpellCheckingInspection
Feature: "Synonyms" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Synonyms" endpoint for the word "wild"
    Then the response has a status code of 200
    And the response body follows the "Synonyms" endpoint JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Synonyms" endpoint for the word "peerless"
    Then the response has a status code of 200
    And the response body follows the "Synonyms" endpoint JSON schema
    And the word field in the response body is "peerless"

  Scenario: Verify returned synonyms against data table
    When I make a GET request to the "Synonyms" endpoint for the word "weather"
    Then the response has a status code of 200
    And the response body follows the "Synonyms" endpoint JSON schema
    And the word has the following synonyms
      | brave                 |
      | brave out             |
      | endure                |
      | upwind                |
      | atmospheric condition |
      | conditions            |
      | weather condition     |

  Scenario: Word has no synonyms
    When I make a GET request to the "Synonyms" endpoint for the word "bison"
    Then the response has a status code of 200
    And the response body follows the "Synonyms" endpoint JSON schema
    And the word has no synonyms

  Scenario: Valid single letter word
    When I make a GET request to the "Synonyms" endpoint for the word "i"
    Then the response has a status code of 200
    And the response body follows the "Synonyms" endpoint JSON schema
    And the word has the following synonyms
      | 1                |
      | ane              |
      | one              |
      | atomic number 53 |
      | iodin            |
      | iodine           |
      | ace              |
      | single           |
      | unity            |

  Scenario: Invalid single letter word
    When I make a GET request to the "Synonyms" endpoint for the word "p"
    Then the response has a status code of 200
    And the response body follows the "Synonyms" endpoint JSON schema
    And the word has the following synonyms
      | atomic number 15 |
      | phosphorus       |

  Scenario: Get synonyms for number instead of word
    When I make a GET request to the "Synonyms" endpoint for the word "6"
    Then the response has a status code of 200
    And the response body follows the "Synonyms" endpoint JSON schema
    And the word has the following synonyms
      | half-dozen    |
      | half dozen    |
      | six           |
      | vi            |
      | captain hicks |
      | half a dozen  |
      | hexad         |
      | sestet        |
      | sextet        |
      | sextuplet     |
      | sise          |
      | sixer         |

  Scenario: Get synonyms of multi-digit number
    When I make a GET request to the "Synonyms" endpoint for the word "500"
    Then the response has a status code of 200
    And the response body follows the "Synonyms" endpoint JSON schema
    And the word has the following synonyms
      | d            |
      | five hundred |

  Scenario: Ordinal numbers have a single synonym
    When I make a GET request to the "Synonyms" endpoint for the word "7th"
    Then the response has a status code of 200
    And the response body follows the "Synonyms" endpoint JSON schema
    And the word has the following synonyms
      | seventh |

  Scenario: Synonyms for numbers as words
    When I make a GET request to the "Synonyms" endpoint for the word "ten"
    Then the response has a status code of 200
    And the response body follows the "Synonyms" endpoint JSON schema
    And the word has the following synonyms
      | ten-spot |
      | 10       |
      | decade   |
      | tenner   |
      | x        |

  Scenario: Synonyms shared by equivalent number and word
    When I make a GET request to the "Synonyms" endpoint for the word "2"
    Then the word has the following synonyms
      | ii    |
      | two   |
      | deuce |
    When I make a GET request to the "Synonyms" endpoint for the word "two"
    Then the word has the following synonyms
      | 2     |
      | ii    |
      | deuce |

  Scenario: Ordinal numbers and words can have different synonyms
    When I make a GET request to the "Synonyms" endpoint for the word "4th"
    And the word has the following synonyms
      | fourth     |
      | quaternary |
    When I make a GET request to the "Synonyms" endpoint for the word "fourth"
    And the word has the following synonyms
      | fourthly            |
      | 4th                 |
      | quaternary          |
      | fourth part         |
      | one-fourth          |
      | one-quarter         |
      | quarter             |
      | quartern            |
      | twenty-five percent |

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Synonyms" endpoint for the phrase "racing car"
    Then the response has a status code of 200
    And the response body follows the "Synonyms" endpoint JSON schema
    And the phrase has the following synonyms
      | race car |
      | racer    |

  Scenario: Hyphenated words
    When I make a GET request to the "Synonyms" endpoint for the word "merry-go-round"
    Then the response has a status code of 200
    And the response body follows the "Synonyms" endpoint JSON schema
    And the word has the following synonyms
      | carousel   |
      | carrousel  |
      | roundabout |
      | whirligig  |

  Scenario: Words containing apostrophes
    When I make a GET request to the "Synonyms" endpoint for the word "you're"
    Then the response has a status code of 200
    And the response body follows the "Synonyms" endpoint JSON schema
    And the word has no synonyms

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Synonyms" endpoint for the word "square"
    And I make a GET request to the "Synonyms" endpoint for the word "SqUaRe"
    And I make a GET request to the "Synonyms" endpoint for the word "SQUARE"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Synonyms" endpoint for the word "bike"
    Then the response has a status code of 200
    And the response body follows the "Synonyms" endpoint JSON schema
    And the word has the following synonyms
      | bicycle    |
      | cycle      |
      | pedal      |
      | wheel      |
      | motorcycle |

  Scenario: Valid initialism
    When I make a GET request to the "Synonyms" endpoint for the word "RV"
    Then the response has a status code of 200
    And the response body follows the "Synonyms" endpoint JSON schema
    And the word has the following synonyms
      | r.v.                 |
      | recreational vehicle |

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "Synonyms" endpoint for the phrase "pro rata"
    Then the response has a status code of 200
    And the response body follows the "Synonyms" endpoint JSON schema
    And the phrase has the following synonyms
      | proportionately |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Synonyms" endpoint for the word "building"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Synonyms" endpoint for the word "building"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Synonyms" endpoint for the word "building"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Synonyms" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/synonyms does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |