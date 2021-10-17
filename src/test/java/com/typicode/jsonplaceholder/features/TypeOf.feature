Feature: "Type Of" Endpoint

  Scenario: Get type of
    When I make a GET request to the "Type Of" endpoint for the word "hatchback"
    Then the response has a status code of 200

