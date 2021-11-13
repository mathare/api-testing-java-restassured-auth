#noinspection SpellCheckingInspection
Feature: "Definitions" Endpoint
  I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
  the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
  I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Definitions" endpoint for the word "screen"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify "word" field in response is requested word
    When I make a GET request to the "Definitions" endpoint for the word "handle"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "handle"

  Scenario: Verify returned definitions against data table
    When I make a GET request to the "Definitions" endpoint for the word "cook"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following definitions
      | definition                                                                                                               | part of Speech |
      | tamper, with the purpose of deception                                                                                    | verb           |
      | English navigator who claimed the east coast of Australia for Britain and discovered several Pacific islands (1728-1779) | noun           |
      | prepare for eating by applying heat                                                                                      | verb           |
      | prepare a hot meal                                                                                                       | verb           |
      | someone who cooks food                                                                                                   | noun           |
      | transform and make suitable for consumption by heating                                                                   | verb           |
      | transform by heating                                                                                                     | verb           |

  Scenario: Word has no definitions
    When I make a GET request to the "Definitions" endpoint for the word "ours"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no definitions

  Scenario: Valid single letter word
    When I make a GET request to the "Definitions" endpoint for the word "i"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following definitions
      | definition                                                                                                                                                                                    | part of Speech |
      | used of a single unit or thing; not two or more                                                                                                                                               | adjective      |
      | a nonmetallic element belonging to the halogens; used especially in medicine and photography and in dyes; occurs naturally only in combination in small quantities (as in sea water or rocks) | noun           |
      | the smallest whole number or a numeral representing this number                                                                                                                               | noun           |
      | the 9th letter of the Roman alphabet                                                                                                                                                          | noun           |

  Scenario: Invalid single letter word
    When I make a GET request to the "Definitions" endpoint for the word "d"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following definitions
      | definition                                                      | part of Speech |
      | a fat-soluble vitamin that prevents rickets                     | noun           |
      | the cardinal number that is the product of one hundred and five | noun           |
      | denoting a quantity consisting of 500 items or units            | adjective      |
      | the 4th letter of the Roman alphabet                            | noun           |

  Scenario: Get definition of number instead of word
    When I make a GET request to the "Definitions" endpoint for the word "5"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following definitions
      | definition                                          | part of Speech |
      | being one more than four                            | adjective      |
      | the cardinal number that is the sum of four and one | noun           |

  Scenario Outline: Number of definitions for number - <number>
    When I make a GET request to the "Definitions" endpoint for the word "<number>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has 2 definitions
    And 1 of the definitions is an adjective
    And 1 of the definitions is a noun
    Examples:
      | number |
      | 0      |
      | 1      |
      | 10     |
      | 100    |

  Scenario: Ordinal numbers have a single definition
    When I make a GET request to the "Definitions" endpoint for the word "3rd"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following definitions
      | definition                                                          | part of Speech |
      | coming next after the second and just before the fourth in position | adjective      |

  Scenario: Numbers as words
    When I make a GET request to the "Definitions" endpoint for the word "seven"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following definitions
      | definition                                                      | part of Speech |
      | the cardinal number that is the sum of six and one              | noun           |
      | being one more than six                                         | adjective      |
      | one of four playing cards in a deck with seven pips on the face | noun           |

  Scenario Outline: Definitions identical for number and word
    When I make a GET request to the "Definitions" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following definitions
      | definition                                              | part of Speech |
      | being one more than thirteen                            | adjective      |
      | the cardinal number that is the sum of thirteen and one | noun           |
    Examples:
      | word     |
      | 14       |
      | fourteen |

  Scenario: Equivalent numbers & words can have different definitions
    When I make a GET request to the "Definitions" endpoint for the word "1"
    Then the word has 2 definitions
    And 1 of the definitions is an adjective
    And 1 of the definitions is a noun
    When I make a GET request to the "Definitions" endpoint for the word "one"
    Then the word has 9 definitions
    And 7 of the definitions are adjectives
    And 2 of the definitions are nouns

  Scenario: Ordinal numbers and words have different definitions
    When I make a GET request to the "Definitions" endpoint for the word "4th"
    Then the word has 1 definition
    And the definition is an adjective
    When I make a GET request to the "Definitions" endpoint for the word "fourth"
    Then the word has 5 definitions
    And 1 of the definitions is an adjective
    And 1 of the definitions is an adverb
    And 3 of the definitions are nouns

  Scenario: Definitions of valid multi-word phrase
    When I make a GET request to the "Definitions" endpoint for the phrase "carving knife"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following definitions
      | definition                              | part of Speech |
      | a large knife used to carve cooked meat | noun           |

  Scenario: Hyphenated word definition
    When I make a GET request to the "Definitions" endpoint for the phrase "yo-yo"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following definitions
      | definition                                                                                | part of Speech |
      | a toy consisting of a spool that is reeled up and down on a string by motions of the hand | noun           |

  Scenario: Words containing apostrophes have no definitions
    When I make a GET request to the "Definitions" endpoint for the word "you're"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has no definitions

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Definitions" endpoint for the word "unspoken"
    And I make a GET request to the "Definitions" endpoint for the word "uNsPoKeN"
    And I make a GET request to the "Definitions" endpoint for the word "UNSPOKEN"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Definitions" endpoint for the word "lab"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following definitions
      | definition                                         | part of Speech |
      | a workplace for the conduct of scientific research | noun           |

  Scenario: Valid initialism
    When I make a GET request to the "Definitions" endpoint for the word "GP"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following definitions
      | definition                                                   | part of Speech |
      | a physician who is not a specialist but treats all illnesses | noun           |

  Scenario: Popular brand name
    When I make a GET request to the "Definitions" endpoint for the word "google"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    Then the word has 2 definitions
    And 1 of the definitions is a noun
    And 1 of the definitions is a verb

  Scenario: Valid foreign phrase used in English
    When I make a GET request to the "Definitions" endpoint for the phrase "deja vu"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following definitions
      | definition                                                          | part of Speech |
      | the experience of thinking that a new situation had occurred before | noun           |

  Scenario: Unauthorised GET request - no API key header
    When I make a GET request without an API key header to the "Definitions" endpoint for the word "ceiling"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key header
    When I make a GET request with an invalid API key header to the "Definitions" endpoint for the word "ceiling"
    Then the response has a status code of 401
    And the response body contains an error message of "Invalid API key. Go to https://docs.rapidapi.com/docs/keys for more info."

  Scenario: Unauthorised GET request - invalid API key value
    When I make a GET request with an invalid API key value to the "Definitions" endpoint for the word "ceiling"
    Then the response has a status code of 403
    And the response body contains an error message of "You are not subscribed to this API."

  Scenario Outline: Unsupported REST verb - <verb>
    When I make a <verb> request to the "Definitions" endpoint for the word "error"
    Then the response has a status code of 404
    And the response body contains an error message of "Endpoint/words/error/definitions does not exist"
    Examples:
      | verb   |
      | PATCH  |
      | POST   |
      | PUT    |
      | DELETE |