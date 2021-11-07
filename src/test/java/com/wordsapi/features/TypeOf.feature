#noinspection CucumberTableInspection, SpellCheckingInspection
Feature: "Type Of" Endpoint
I wouldn't generally validate the schema for every response but having identified issues with the documented schema for
the "Everything" endpoint I have chosen to add the schema validation step to all tests so that I can be sure the schema
I am using is as expected

  Scenario: Verify response schema and body
    When I make a GET request to the "Type Of" endpoint for the word "hatchback"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario: Verify returned types against data table
    When I make a GET request to the "Type Of" endpoint for the word "bottle"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
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
    And the response body follows the expected JSON schema
    And the word is not a "type of" anything

  Scenario: Word not in dictionary returns error
    When I make a GET request to the "Type Of" endpoint for the word "api"
    Then the response has a status code of 404
    And the response body follows the error JSON schema
    And the response body contains an error message of "word not found"

  Scenario: Valid single letter word
    When I make a GET request to the "Type Of" endpoint for the word "a"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
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
    And the response body follows the expected JSON schema
    And the word is an example of the following types
      | alphabetic character   |
      | letter                 |
      | letter of the alphabet |

  Scenario: Get type of number instead of word
    When I make a GET request to the "Type Of" endpoint for the word "1"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is an example of the following types
      | digit  |
      | figure |

  Scenario: Get type of multi-digit number
    When I make a GET request to the "Type Of" endpoint for the word "10"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is an example of the following types
      | large integer |

  Scenario Outline: Get type of <description> number
    When I make a GET request to the "Type Of" endpoint for the word "<number>"
    Then the response has a status code of 404
    And the response body follows the error JSON schema
    And the response body contains an error message of "word not found"
    Examples:
      | description | number |
      | non-integer | 1.0    |
      | negative    | -1     |

