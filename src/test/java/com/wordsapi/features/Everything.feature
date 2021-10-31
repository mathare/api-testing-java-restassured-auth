Feature: "Everything" Endpoint

  Scenario: Verify response schema and body
    When I make a GET request to the "Everything" endpoint for the word "example"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body matches the expected response

  Scenario Outline: Verify "word" field in response is requested word
    When I make a GET request to the "Everything" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word field in the response body is "<word>"
    Examples:
      | word     |
      | computer |
      | mouse    |
      | test     |

  Scenario Outline: Words can have multiple definitions (results) - <word>
    When I make a GET request to the "Everything" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the response body contains <definitions> definitions
    Examples:
      | word    | definitions |
      | my      | 0           |
      | peptide | 1           |
      | dog     | 8           |
      | set     | 45          |
    
  Scenario: Verify definition for word with single result
    When I make a GET request to the "Everything" endpoint for the word "caribou"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the definition is
    """
    Arctic deer with large antlers in both sexes; called `reindeer' in Eurasia and `caribou' in North America
    """

  Scenario: Verify definitions for word with multiple results
    When I make a GET request to the "Everything" endpoint for the word "shelf"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the definitions are
      | a projecting ridge on a mountain or submerged under water           |
      | a support that consists of a horizontal surface for holding objects |

  Scenario Outline: All definitions are same part of speech - <part of speech>
    When I make a GET request to the "Everything" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And all the definitions are <part of speech>
    Examples:
      | word       | part of speech |
      | incredible | adjectives     |
      | lovingly   | adverbs        |
      | violin     | nouns          |
      | to         | prepositions   |
      | this       | pronoun        |
      | occur      | verbs          |

  Scenario Outline: Definitions cover multiple parts of speech - <word>
    When I make a GET request to the "Everything" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And <adjectives> of the definitions are adjectives
    And <adverbs> of the definitions are adverbs
    And <nouns> of the definitions are nouns
    And <verbs> of the definitions are verbs
    Examples:
      | word  | adjectives | adverbs | nouns | verbs |
      | blue  | 8          | 0       | 7     | 1     |
      | fast  | 9          | 1       | 1     | 2     |
      | house | 0          | 0       | 12    | 2     |

  Scenario: Verify "also" field in results
    When I make a GET request to the "Everything" endpoint for the word "awake"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "also" field in the 3rd result has the following values
      | cognisant |
      | alert     |
      | conscious |
      | watchful  |
      | aware     |
      | cognizant |

  Scenario: Verify "antonyms" field in results
    When I make a GET request to the "Everything" endpoint for the word "profit"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "antonyms" field in the 2nd result has the following values
      | break even |
      | lose       |

