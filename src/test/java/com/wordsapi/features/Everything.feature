Feature: "Everything" Endpoint

  Scenario: Verify response schema and body
    When I make a GET request to the "Everything" endpoint for the word "example"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response


  Scenario Outline: Words can have multiple definitions (results) - <word>
  # No word should have 0 definitions else it wouldn't be in the dictionary and thus not part of the API words list
    When I make a GET request to the "Everything" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body contains <definitions> definitions
    Examples:
      | word    | definitions |
      | peptide | 1           |
      | dog     | 8           |
      | set     | 45          |
