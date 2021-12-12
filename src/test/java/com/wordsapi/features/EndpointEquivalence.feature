Feature: Endpoint Equivalence
  Rather than testing a specific endpoint, this feature contains a single scenario outline demonstrating the equivalence
  between individual endpoints and the main ("Everything") endpoint. What I mean by this is the "Everything" response
  for a given word contains fields that should be the same as that in the response for the equivalent endpoint - the
  "also" field in the "Everything" endpoint response should be identical to the "also" field in the "Also" endpoint
  response and so on.

  Some endpoints require more complicated comparisons against the "Everything" response - in particular, the Definitions,
  Frequency, Pronunciation, Rhymes and Syllables endpoints. I have omitted these from this test for simplicity as this is
  just a demonstration project but if this were an API the company I was working for had developed I would of course
  ensure full coverage of all endpoints.

  Scenario Outline: <endpoint> endpoint equivalence
    When I make a GET request to the "Everything" endpoint for the word "<word>"
    And I make a GET request to the "<endpoint>" endpoint for the word "<word>"
    Then the "<field>" field in both response bodies is identical
    Examples:
      | endpoint       | word          | field         |
      | Also           | inedible      | also          |
      | Antonyms       | homogeneity   | antonyms      |
      | Entails        | bend          | entails       |
      | Examples       | clamp         | examples      |
      | Has Categories | shipping      | hasCategories |
      | Has Instances  | troubadour    | hasInstances  |
      | Has Members    | merlangus     | hasMembers    |
      | Has Parts      | calorie       | hasParts      |
      | Has Substances | seawater      | hasSubstances |
      | Has Types      | stain         | hasTypes      |
      | Has Usages     | superlative   | hasUsages     |
      | In Category    | clog          | inCategory    |
      | In Region      | chuffed       | inRegion      |
      | Instance Of    | hubbard       | instanceOf    |
      | Member Of      | gumbo         | memberOf      |
      | Part Of        | depression    | partOf        |
      | Pertains To    | juridic       | pertainsTo    |
      | Region Of      | ardennes      | regionOf      |
      | Similar To     | urbane        | similarTo     |
      | Substance Of   | intensity     | substanceOf   |
      | Synonyms       | unbelievingly | synonyms      |
      | Type Of        | abbess        | typeOf        |
      | Usage Of       | proto         | usageOf       |