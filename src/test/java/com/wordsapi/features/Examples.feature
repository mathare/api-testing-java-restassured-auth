#noinspection SpellCheckingInspection
Feature: "Examples" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Examples" endpoint for the word "table"
    Then the response has a status code of 200
    And the response body follows the "Examples" endpoint JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Examples" endpoint for the word "glass"
    Then the response has a status code of 200
    And the response body follows the "Examples" endpoint JSON schema
    And the word field in the response body is "glass"

  Scenario: Verify returned examples against data table
    When I make a GET request to the "Examples" endpoint for the word "plate"
    Then the response has a status code of 200
    And the response body follows the "Examples" endpoint JSON schema
    And the word has the following examples
      | a vegetable plate        |
      | the blue plate special   |
      | plate spoons with silver |

  Scenario: Word has no examples
    When I make a GET request to the "Examples" endpoint for the word "coaster"
    Then the response has a status code of 200
    And the response body follows the "Examples" endpoint JSON schema
    And the word has no examples

  Scenario: Valid single letter word
    When I make a GET request to the "Examples" endpoint for the word "a"
    Then the response has a status code of 200
    And the response body follows the "Examples" endpoint JSON schema
    And the word has the following examples
      | a typical household circuit carries 15 to 50 amps |

  Scenario: Invalid single letter word
    When I make a GET request to the "Examples" endpoint for the word "y"
    Then the response has a status code of 200
    And the response body follows the "Examples" endpoint JSON schema
    And the word has no examples

  Scenario: Get examples of number instead of word
    When I make a GET request to the "Examples" endpoint for the word "7"
    Then the response has a status code of 200
    And the response body follows the "Examples" endpoint JSON schema
    And the word has no examples

  Scenario: Ordinal numbers have no examples
    When I make a GET request to the "Examples" endpoint for the word "1st"
    Then the response has a status code of 200
    And the response body follows the "Examples" endpoint JSON schema
    And the word has no examples

  Scenario: Numbers as words
    When I make a GET request to the "Examples" endpoint for the word "two"
    Then the response has a status code of 200
    And the response body follows the "Examples" endpoint JSON schema
    And the word has the following examples
      | he received two messages |

  Scenario: Not all numbers as words have examples
    When I make a GET request to the "Examples" endpoint for the word "three"
    Then the response has a status code of 200
    And the response body follows the "Examples" endpoint JSON schema
    And the word has no examples

  Scenario: Equivalent numbers & words have different examples
    When I make a GET request to the "Examples" endpoint for the word "1"
    Then the word has no examples
    When I make a GET request to the "Examples" endpoint for the word "one"
    Then the word has the following examples
      | that is one fine dog                                       |
      | spoke with one voice                                       |
      | he has the one but will need a two and three to go with it |
      | they had lunch at one                                      |
      | she's one girl in a million                                |
      | the one and only Muhammad Ali                              |
      | he is the best one                                         |
      | this is the one I ordered                                  |
      | three chemicals combining into one solution                |
      | he will come one day                                       |
      | one place or another                                       |
      | two animals of one species                                 |

  Scenario: Ordinal numbers and words have different examples
    When I make a GET request to the "Examples" endpoint for the word "5th"
    Then the word has no examples
    When I make a GET request to the "Examples" endpoint for the word "fifth"
    Then the word has the following examples
      | he was fifth out of several hundred runners |

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Examples" endpoint for the phrase "point of view"
    Then the response has a status code of 200
    And the response body follows the "Examples" endpoint JSON schema
    And the phrase has the following examples
      | teaching history gave him a special point of view toward current events |

  Scenario: Hyphenated words
    When I make a GET request to the "Examples" endpoint for the word "cookie-cutter"
    Then the response has a status code of 200
    And the response body follows the "Examples" endpoint JSON schema
    And the word has the following examples
      | a suburb of cookie-cutter houses |

  Scenario: Words containing apostrophes
    When I make a GET request to the "Examples" endpoint for the word "you're"
    Then the response has a status code of 200
    And the response body follows the "Examples" endpoint JSON schema
    And the word has no examples

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Examples" endpoint for the word "chorus"
    And I make a GET request to the "Examples" endpoint for the word "cHoRuS"
    And I make a GET request to the "Examples" endpoint for the word "CHORUS"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Examples" endpoint for the word "detox"
    Then the response has a status code of 200
    And the response body follows the "Examples" endpoint JSON schema
    And the word has the following examples
      | He was detoxified in the clinic |

  Scenario: Valid initialism
    When I make a GET request to the "Examples" endpoint for the word "PC"
    Then the response has a status code of 200
    And the response body follows the "Examples" endpoint JSON schema
    And the word has no examples

  Scenario: Popular brand name
    When I make a GET request to the "Examples" endpoint for the word "google"
    Then the response has a status code of 200
    And the response body follows the "Examples" endpoint JSON schema
    And the word has the following examples
      | He googled the woman he had met at the party |

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "Examples" endpoint for the phrase "a priori"
    Then the response has a status code of 200
    And the response body follows the "Examples" endpoint JSON schema
    And the phrase has the following examples
      | an a priori judgment |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Examples" endpoint for the word "window"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Examples" endpoint for the word "window"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Examples" endpoint for the word "window"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Examples" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/examples does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |