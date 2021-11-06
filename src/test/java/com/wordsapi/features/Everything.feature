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
    And there is no "also" field in the other results

  Scenario: Verify "antonyms" field in results
    When I make a GET request to the "Everything" endpoint for the word "profit"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "antonyms" field in the 2nd result has the following values
      | break even |
      | lose       |
    And there is no "antonyms" field in the other results

  Scenario: Verify "attribute" field in results
    When I make a GET request to the "Everything" endpoint for the word "time"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "attribute" field in the 1st result has the following values
      | antemeridian |
      | postmeridian |
    And there is no "attribute" field in the other results

  Scenario: Verify "cause" field in results
    When I make a GET request to the "Everything" endpoint for the word "work"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "cause" field in the 9th result has the following values
      | do work |
    And the "cause" field in the 18th result has the following values
      | turn    |
      | ferment |
      | sour    |
    And the "cause" field in the 20th result has the following values
      | exercise |
      | work out |
    And there is no "cause" field in the other results

  Scenario: Verify "derivation" field in results
    When I make a GET request to the "Everything" endpoint for the word "puzzle"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "derivation" field in the 1st result has the following values
      | puzzlement |
      | puzzler    |
    And the "derivation" field in the 4th result has the following values
      | puzzlement |
    And there is no "derivation" field in the other results

  Scenario: Verify "entails" field in results
    When I make a GET request to the "Everything" endpoint for the word "touch"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "entails" field in the 2nd result has the following values
      | refer  |
      | denote |
    And there is no "entails" field in the other results

  Scenario: Verify "examples" field in results
    When I make a GET request to the "Everything" endpoint for the word "story"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "examples" field in the 1st result has the following values
      | a history of France           |
      | the story of exposure to lead |
    And the "examples" field in the 3rd result has the following values
      | the story was on the 11 o'clock news |
    And there is no "examples" field in the other results

  Scenario: Verify "hasCategories" field in results
    When I make a GET request to the "Everything" endpoint for the word "science"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "hasCategories" field in the 2nd result has the following values
      | theorizer    |
      | verify       |
      | theorist     |
      | idealogue    |
      | theoretician |
      | control      |
      | theoriser    |
      | maths        |
      | mathematics  |
      | math         |
    And there is no "hasCategories" field in the other results

  Scenario: Verify "hasInstances" field in results
    When I make a GET request to the "Everything" endpoint for the word "ocean"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "hasInstances" field in the 2nd result has the following values
      | pacific ocean   |
      | indian ocean    |
      | arctic ocean    |
      | atlantic        |
      | atlantic ocean  |
      | antarctic ocean |
      | pacific         |
    And there is no "hasInstances" field in the other results

  Scenario: Verify "hasMembers" field in results
    When I make a GET request to the "Everything" endpoint for the word "pantheon"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "hasMembers" field in the 1st result has the following values
      | god      |
      | deity    |
      | divinity |
      | immortal |
    And there is no "hasMembers" field in the other results

  Scenario: Verify "hasParts" field in results
    When I make a GET request to the "Everything" endpoint for the word "dress"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "hasParts" field in the 4th result has the following values
      | neckline       |
      | slide fastener |
      | bodice         |
      | zip            |
      | zip fastener   |
      | zipper         |
      | hemline        |
    And there is no "hasParts" field in the other results

  Scenario: Verify "hasSubstances" field in results
    When I make a GET request to the "Everything" endpoint for the word "meat"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "hasSubstances" field in the 3rd result has the following values
      | hexadecanoic acid |
      | palmitic acid     |
      | protein           |
    And there is no "hasSubstances" field in the other results

  Scenario: Verify "hasTypes" field in results
    When I make a GET request to the "Everything" endpoint for the word "blanket"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "hasTypes" field in the 1st result has the following values
      | afghan           |
      | electric blanket |
      | mackinaw         |
      | mackinaw blanket |
      | manta            |
      | security blanket |
    And there is no "hasTypes" field in the other results

  Scenario: Verify "hasUsages" field in results
    When I make a GET request to the "Everything" endpoint for the word "superlative"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "hasUsages" field in the 4th result has the following values
      | nighest |
      | best    |
      | fewest  |
      | least   |
      | most    |
      | worst   |
      | closest |
      | nearest |
    And there is no "hasUsages" field in the other results

  Scenario: Verify "inCategory" field in results
    When I make a GET request to the "Everything" endpoint for the word "assault"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "inCategory" field in the 6th result has the following values
      | armed services   |
      | war machine      |
      | armed forces     |
      | military machine |
      | military         |
    And there is no "inCategory" field in the other results

  Scenario: Verify "inRegion" field in results
    When I make a GET request to the "Everything" endpoint for the word "gladiator"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "inRegion" field in the 2nd result has the following values
      | roma             |
      | italian capital  |
      | capital of italy |
      | rome             |
      | eternal city     |
    And there is no "inRegion" field in the other results

  Scenario: Verify "instanceOf" field in results
    When I make a GET request to the "Everything" endpoint for the word "devil"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "instanceOf" field in the 1st result has the following values
      | spiritual being    |
      | supernatural being |
    And there is no "instanceOf" field in the other results

  Scenario: Verify "memberOf" field in results
    When I make a GET request to the "Everything" endpoint for the word "oyster"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "memberOf" field in the 4th result has the following values
      | ostreidae        |
      | family ostreidae |
    And there is no "memberOf" field in the other results

  Scenario: Verify "partOf" field in results
    When I make a GET request to the "Everything" endpoint for the word "vessel"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "partOf" field in the 2nd result has the following values
      | vascular system |
    And there is no "partOf" field in the other results

  Scenario: Verify "pertainsTo" field in results
    When I make a GET request to the "Everything" endpoint for the word "choral"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "pertainsTo" field in the 2nd result has the following values
      | chorus |
    And there is no "pertainsTo" field in the other results

  Scenario: Verify "regionOf" field in results
    When I make a GET request to the "Everything" endpoint for the word "atlantic"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "regionOf" field in the 1st result has the following values
      | battle of trafalgar |
      | trafalgar           |
    And there is no "regionOf" field in the other results

  Scenario: Verify "similarTo" field in results
    When I make a GET request to the "Everything" endpoint for the word "sandy"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "similarTo" field in the 1st result has the following values
      | blond        |
      | blonde       |
      | light-haired |
    And there is no "similarTo" field in the other results

  Scenario: Verify "substanceOf" field in results
    When I make a GET request to the "Everything" endpoint for the word "cocoa"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "substanceOf" field in the 2nd result has the following values
      | hot chocolate      |
      | drinking chocolate |
      | chocolate          |
    And there is no "substanceOf" field in the other results

  Scenario: Verify "synonyms" field in results
    When I make a GET request to the "Everything" endpoint for the word "cane"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "synonyms" field in the 1st result has the following values
      | flog     |
      | lambast  |
      | lambaste |
    And there is no "synonyms" field in the other results

  Scenario: Verify "typeOf" field in results
    When I make a GET request to the "Everything" endpoint for the word "dripping"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "typeOf" field in the 1st result has the following values
      | sound |
    And the "typeOf" field in the 3rd result has the following values
      | flow    |
      | flowing |
    And there is no "typeOf" field in the other results

  Scenario: Verify "usageOf" field in results
    When I make a GET request to the "Everything" endpoint for the word "mighty"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "usageOf" field in the 1st result has the following values
      | intensifier |
      | intensive   |
    And there is no "usageOf" field in the other results

  Scenario: Verify "verbGroup" field in results
    When I make a GET request to the "Everything" endpoint for the word "shed"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the "verbGroup" field in the 3rd result has the following values
      | slop     |
      | spill    |
      | splatter |
    And there is no "verbGroup" field in the other results

  # For some reason it only seems to be pronouns that have a rhyme defined
  Scenario Outline: Verify rhyme for word with single rhyme - <word>
    When I make a GET request to the "Everything" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word rhymes with "<rhyme>"
    Examples:
      | word  | rhyme |
      | his   | -ɪz   |
      | our   | -aʊr  |
      | their | -r    |

  Scenario Outline: Verify number of syllables - <word>
    When I make a GET request to the "Everything" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has <syllables> syllables
    Examples:
      | word                    | syllables |
      | scourge                 | 1         |
      | keyboard                | 2         |
      | area                    | 3         |
      | triangular              | 4         |
      | vermiculated            | 5         |
      | gubernatorial           | 6         |
      | overindividualistically | 11        |

  Scenario: Verify breakdown of syllables
    When I make a GET request to the "Everything" endpoint for the word "automation"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following syllables
      | au   |
      | to   |
      | ma   |
      | tion |

  Scenario: Word with single pronunciation
    When I make a GET request to the "Everything" endpoint for the word "duplicate"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word is pronounced "'du,pləkeɪt"

  Scenario: Word with multiple pronunciations
    When I make a GET request to the "Everything" endpoint for the word "effect"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has the following pronunciations
      | noun | 'ɪ,fɛkt |
      | verb | ,ɪ'fɛkt |

  Scenario Outline: Verify frequency - <word>
    When I make a GET request to the "Everything" endpoint for the word "<word>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    And the word has a frequency of <frequency>
    Examples:
      | word        | frequency |
      | machination | 1.97      |
      | wardrobe    | 3.71      |
      | I           | 7.56      |

  Scenario: Word not in dictionary returns error
    When I make a GET request to the "Everything" endpoint for the word "api"
    Then the response has a status code of 404
    And the response body follows the error JSON schema
    And the response body contains an error message of "word not found"

  Scenario: Valid single letter word
    When I make a GET request to the "Everything" endpoint for the word "a"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema

  Scenario: Invalid single letter word
    When I make a GET request to the "Everything" endpoint for the word "q"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema

  Scenario: Number instead of word
    When I make a GET request to the "Everything" endpoint for the word "1"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema

  Scenario Outline: Invalid number - <description>
    When I make a GET request to the "Everything" endpoint for the word "<number>"
    Then the response has a status code of 404
    And the response body follows the error JSON schema
    And the response body contains an error message of "word not found"
    Examples:
      | description | number |
      | non-integer | 1.0    |
      | negative    | -1     |

  Scenario: Words containing numbers
    When I make a GET request to the "Everything" endpoint for the word "1st"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema

  Scenario: Numbers as words
    When I make a GET request to the "Everything" endpoint for the word "one"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema

  Scenario: Valid multi-word phrase
    When I make a GET request to the "Everything" endpoint for the phrase "vitamin C"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema

  Scenario: Invalid multi-word phrase
    When I make a GET request to the "Everything" endpoint for the phrase "computer desk"
    Then the response has a status code of 404
    And the response body follows the error JSON schema
    And the response body contains an error message of "word not found"

  Scenario: Hyphenated words
    When I make a GET request to the "Everything" endpoint for the word "mother-in-law"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema

  Scenario: Words containing apostrophes
    When I make a GET request to the "Everything" endpoint for the word "shouldn't"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema

  Scenario: Word parameter is not case sensitive
    When I make a GET request to the "Everything" endpoint for the word "canoe"
    And I make a GET request to the "Everything" endpoint for the word "cAnOe"
    And I make a GET request to the "Everything" endpoint for the word "CANOE"
    Then all response bodies are identical

  Scenario: Commonly abbreviated word
    When I make a GET request to the "Everything" endpoint for the word "flu"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema

  Scenario: Valid initialism
    When I make a GET request to the "Everything" endpoint for the word "AA"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema

  Scenario: Invalid initialism
    When I make a GET request to the "Everything" endpoint for the word "MSN"
    Then the response has a status code of 404
    And the response body follows the error JSON schema
    And the response body contains an error message of "word not found"

  Scenario Outline: Popular brand names - <word>
    When I make a GET request to the "Everything" endpoint for the word "<word>"
    Then the response has a status code of <status code>
    And the response body follows the <schema> JSON schema
    Examples:
      | word      | status code | schema   |
      | Google    | 200         | expected |
      | Microsoft | 200         | expected |
      | Facebook  | 404         | error    |

  Scenario Outline: Word containing invalid special character - <word>
    When I make a GET request to the "Everything" endpoint for the word "<word>"
    Then the response has a status code of 404
    And the response body follows the error JSON schema
    And the response body contains an error message of "word not found"
    Examples:
      | word  |
      | R&D   |
      | R & D |

  Scenario Outline: Valid foreign phrases used in English - <phrase>
    When I make a GET request to the "Everything" endpoint for the phrase "<phrase>"
    Then the response has a status code of 200
    And the response body follows the expected JSON schema
    Examples:
      | phrase        |
      | caveat emptor |
      | fait accompli |

  Scenario: Abbreviated phrase without punctuation raises error
    When I make a GET request to the "Everything" endpoint for the phrase "eg"
    Then the response has a status code of 404
    And the response body follows the error JSON schema
    And the response body contains an error message of "word not found"

  Scenario: Abbreviated phrase with punctuation is valid
    When I make a GET request to the "Everything" endpoint for the phrase "e.g."
    Then the response has a status code of 200
    And the response body follows the expected JSON schema

  Scenario: Responses for puncuatated and non-punctuated abbreviated phrase differ
    When I make a GET request to the "Everything" endpoint for the word "etc"
    And I make a GET request to the "Everything" endpoint for the word "etc."
    Then the response bodies differ

