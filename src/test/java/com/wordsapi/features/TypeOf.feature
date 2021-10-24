Feature: "Type Of" Endpoint

  Scenario: Get type of "hatchback"
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
