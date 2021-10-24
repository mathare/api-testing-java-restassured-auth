Feature: "Type Of" Endpoint

  Scenario: Get type of "hatchback"
    When I make a GET request to the "Type Of" endpoint for the word "hatchback"
    Then the response has a status code of 200
    And the response body follows the "Type Of" JSON schema
    And the response body matches the expected response

