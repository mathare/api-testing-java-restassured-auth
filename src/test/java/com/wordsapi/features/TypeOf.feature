#noinspection SpellCheckingInspection
Feature: "Type Of" Endpoint
I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Type Of" endpoint for the word "hatchback"
    Then the response has a status code of 200
    And the response body follows the "TypeOf" endpoint JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Type Of" endpoint for the word "container"
    Then the response has a status code of 200
    And the response body follows the "TypeOf" endpoint JSON schema
    And the word field in the response body is "container"

  Scenario: Verify returned types against data table
    When I make a GET request to the "Type Of" endpoint for the word "bottle"
    Then the response has a status code of 200
    And the response body follows the "TypeOf" endpoint JSON schema
    And the word is an example of the following types
      | containerful |
      | vessel       |
      | place        |
      | pose         |
      | put          |
      | set          |
      | lay          |
      | position     |
      | store        |

  Scenario: Word is not type of anything
    When I make a GET request to the "Type Of" endpoint for the word "unique"
    Then the response has a status code of 200
    And the response body follows the "TypeOf" endpoint JSON schema
    And the word is not a type of anything

  Scenario: Valid single letter word
    When I make a GET request to the "Type Of" endpoint for the word "a"
    Then the response has a status code of 200
    And the response body follows the "TypeOf" endpoint JSON schema
    And the word is an example of the following types
      | nucleotide             |
      | base                   |
      | blood group            |
      | blood type             |
      | fat-soluble vitamin    |
      | current unit           |
      | metric linear unit     |
      | purine                 |
      | letter                 |
      | alphabetic character   |
      | letter of the alphabet |

  Scenario: Invalid single letter word
    When I make a GET request to the "Type Of" endpoint for the word "q"
    Then the response has a status code of 200
    And the response body follows the "TypeOf" endpoint JSON schema
    And the word is an example of the following types
      | alphabetic character   |
      | letter                 |
      | letter of the alphabet |

  Scenario: Get type of number instead of word
    When I make a GET request to the "Type Of" endpoint for the word "2"
    Then the response has a status code of 200
    And the response body follows the "TypeOf" endpoint JSON schema
    And the word is an example of the following types
      | digit  |
      | figure |

  Scenario: Get type of multi-digit number
    When I make a GET request to the "Type Of" endpoint for the word "12"
    Then the response has a status code of 200
    And the response body follows the "TypeOf" endpoint JSON schema
    And the word is an example of the following types
      | large integer |

  Scenario: Ordinal numbers are not a type of anything
    When I make a GET request to the "Type Of" endpoint for the word "1st"
    Then the response has a status code of 200
    And the response body follows the "TypeOf" endpoint JSON schema
    And the word is not a type of anything

  Scenario: Numbers as words
    When I make a GET request to the "Type Of" endpoint for the word "three"
    Then the response has a status code of 200
    And the response body follows the "TypeOf" endpoint JSON schema
    And the word is an example of the following types
      | digit        |
      | figure       |
      | playing card |

  Scenario Outline: Types identical for number and word
    When I make a GET request to the "Type Of" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the "TypeOf" endpoint JSON schema
    And the word is an example of the following types
      | large integer |
    Examples:
      | word   |
      | 12     |
      | twelve |

  Scenario: Not all numbers & words have identical types
    When I make a GET request to the "Type Of" endpoint for the word "1"
    Then the word is an example of the following types
      | digit  |
      | figure |
    When I make a GET request to the "Type Of" endpoint for the word "one"
    Then the word is an example of the following types
      | digit  |
      | figure |
      | unit   |

  Scenario: Ordinal numbers and words have different types
    When I make a GET request to the "Type Of" endpoint for the word "1st"
    Then the word is not a type of anything
    When I make a GET request to the "Type Of" endpoint for the word "first"
    Then the word is an example of the following types
      | position       |
      | point          |
      | point in time  |
      | gear mechanism |
      | gear           |
      | ordinal number |
      | no.            |
      | ordinal        |
      | rank           |
      | honours degree |
      | honours        |

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Type Of" endpoint for the phrase "vitamin D"
    Then the response has a status code of 200
    And the response body follows the "TypeOf" endpoint JSON schema
    And the phrase is an example of the following types
      | fat-soluble vitamin |

  Scenario: Hyphenated words
    When I make a GET request to the "Type Of" endpoint for the word "father-in-law"
    Then the response has a status code of 200
    And the response body follows the "TypeOf" endpoint JSON schema
    And the word is an example of the following types
      | begetter        |
      | father          |
      | in-law          |
      | male parent     |
      | relative-in-law |

  Scenario: Words containing apostrophes
    When I make a GET request to the "Type Of" endpoint for the word "we've"
    Then the response has a status code of 200
    And the response body follows the "TypeOf" endpoint JSON schema
    And the word is not a type of anything

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Type Of" endpoint for the word "chair"
    And I make a GET request to the "Type Of" endpoint for the word "ChAiR"
    And I make a GET request to the "Type Of" endpoint for the word "CHAIR"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Type Of" endpoint for the word "flu"
    Then the response has a status code of 200
    And the response body follows the "TypeOf" endpoint JSON schema
    And the word is an example of the following types
      | respiratory disorder |
      | respiratory illness  |
      | contagion            |
      | contagious disease   |
      | respiratory disease  |

  Scenario: Valid initialism
    When I make a GET request to the "Type Of" endpoint for the word "NGO"
    Then the response has a status code of 200
    And the response body follows the "TypeOf" endpoint JSON schema
    And the word is an example of the following types
      | organization |
      | organisation |

  Scenario: Popular brand name
    When I make a GET request to the "Type Of" endpoint for the word "google"
    Then the response has a status code of 200
    And the response body follows the "TypeOf" endpoint JSON schema
    And the word is an example of the following types
      | explore  |
      | research |
      | search   |

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "Type Of" endpoint for the phrase "modus operandi"
    Then the response has a status code of 200
    And the response body follows the "TypeOf" endpoint JSON schema
    And the phrase is an example of the following types
      | procedure |
      | process   |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Type Of" endpoint for the word "floor"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Type Of" endpoint for the word "floor"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Type Of" endpoint for the word "floor"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Type Of" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/typeof does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |