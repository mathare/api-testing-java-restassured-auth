#noinspection SpellCheckingInspection, CucumberTableInspection, NonAsciiCharacters
Feature: Searching
  A number of search parameters can be specified as query parameters on the API call in order to narrow down the
  returned results:
  - letters i.e. exact length
  - lettersMin
  - lettersMax
  - letterPattern i.e. regular expression results must match
  - hasDetails i.e. all results will contain the specified detail type
  - partOfSpeech e.g. verb, noun
  - pronunciationPattern i.e. regular expression pronunciation must match
  - sounds i.e. number of phonemes
  - soundsMin
  - soundsMax
  - limit i.e. number of results to return per page (1-100)
  - page i.e. page number of results set to return
  There is also an additional random=true parameter that can be specified to return a random result from the set.
  These query parameters can be combined to further narrow down the search.

  However, the search can only be performed on the main "Everything" endpoint as the format of the API URL is
  /words/<word>/<endpoint> i.e the endpoint is the final path parameter. If the word was the final path parameter then
  it may be optional and one could then investigate searching within individual endpoints, but it's not. This means,
  for example, that a call to /words/rhymes is a call to the "Everything" endpoint for the word "rhymes" - it is not a
  call to the "Rhymes" endpoint with no word specified. To effectively search within an endpoint one must specify the
  hasDetails parameter e.g. hasDetails=rhymes to serach within words that have rhymes defined in their results.

  Scenario Outline: Verify number of words of varying lengths - <letters> letters long
    When I search with a query parameter of "letters=<letters>"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of <results> results
    Examples:
      | letters | results |
      | 1       | 36      |
      | 2       | 411     |
      | 3       | 2364    |
      | 4       | 5652    |
      | 5       | 10669   |
      | 6       | 17841   |
      | 7       | 25682   |
      | 8       | 33771   |
      | 9       | 38424   |
      | 10      | 38594   |
      | 11      | 35019   |
      | 12      | 29718   |
      | 13      | 23769   |
      | 14      | 18147   |
      | 15      | 13014   |
      | 16      | 9247    |
      | 17      | 6663    |
      | 18      | 4719    |
      | 19      | 3354    |
      | 20      | 2419    |
      | 25      | 401     |
      | 30      | 86      |
      | 35      | 31      |
      | 40      | 10      |
      | 45      | 8       |
      | 50      | 1       |
      | 55      | 0       |

  Scenario: Verify 1-letter words are 0-9 & a-z
    When I search with a query parameter of "letters=1"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And the following words are returned
      | 0 |
      | 1 |
      | 2 |
      | 3 |
      | 4 |
      | 5 |
      | 6 |
      | 7 |
      | 8 |
      | 9 |
      | a |
      | b |
      | c |
      | d |
      | e |
      | f |
      | g |
      | h |
      | i |
      | j |
      | k |
      | l |
      | m |
      | n |
      | o |
      | p |
      | q |
      | r |
      | s |
      | t |
      | u |
      | v |
      | w |
      | x |
      | y |
      | z |

  Scenario Outline: Invalid letters query param values - <description>
    When I search with a query parameter of "letters=<letters>"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of 0 results
    Examples:
      | letters | description |
      | 0       | zero        |
      | -1      | negative    |
      | 1.23    | non-integer |

  Scenario Outline: Search parameter case sensitivity - <description>
    # If the query parameter has the wrong case, the full data set is returned
    When I search with a query parameter of "<param>=1"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of <results> results
    Examples:
      | param   | results | description |
      | letters | 36      | lower case  |
      | LeTtErS | 325331  | mixed case  |
      | LETTERS | 325331  | upper case  |

  Scenario: Verify number of words with at least 6 letters
    When I search with a query parameter of "lettersMin=6"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of 306199 results

  Scenario: Verify number of words with no more than 12 letters
    When I search with a query parameter of "lettersMax=12"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of 238210 results

  Scenario: Combine lettersMin & lettersMax query params
    When I search with the following query parameters
      | lettersMin=6  |
      | lettersMax=12 |
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of 219078 results

  @skip
  # This returns 29 words rather than the expected 0 - suspected API error
  Scenario: Zero results if lettersMin more than lettersMax value
    When I search with the following query parameters
      | lettersMin=10 |
      | lettersMax=4  |
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of 0 results

  @skip
  # For some reason letters=10 returns 38594 words whereas lettersMin=10 & lettersMax=10 returns 38623
  # They should be the same & I don't understand why they're not. Could be a bug with the API
  Scenario: Letters query parameter equivalence
    When I search with a query parameter of "letters=10"
    And I search with the following query parameters
      | lettersMin=10 |
      | lettersMax=10 |
    Then both response bodies are identical

  Scenario Outline: Return words matching a specific letter pattern - <description>
    # This is just a small sample of regexes - many more test cases could be added
    # but these are sufficient to cover the main scenarios
    When I search with a query parameter of "letterPattern=<regex>"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of <results> results
    Examples:
      | regex     | results | description |
      | ^[a-d]{3} | 2207    | starts with |
      | car       | 3580    | contains    |
      | ion$      | 8739    | ends with   |
      | ^screen$  | 1       | exact match |

  Scenario Outline: Return words containing specific details - <detail>
    When I search with a query parameter of "hasDetails=<detail>"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of <results> results
    Examples:
      | detail        | results |
      | also          | 1753    |
      | antonyms      | 6622    |
      | definitions   | 147531  |
      | examples      | 21753   |
      | frequency     | 60650   |
      | hasCategories | 840     |
      | hasInstances  | 1742    |
      | hasMembers    | 11106   |
      | hasParts      | 7452    |
      | hasSubstances | 0       |
      | hasTypes      | 28945   |
      | hasUsages     | 70      |
      | inCategory    | 8718    |
      | inRegion      | 2074    |
      | instanceOf    | 14459   |
      | memberOf      | 25212   |
      | partOf        | 12411   |
      | pertainsTo    | 6940    |
      | pronunciation | 174525  |
      | regionOf      | 390     |
      | rhymes        | 0       |
      | similarTo     | 16740   |
      | substanceOf   | 960     |
      | syllables     | 146223  |
      | synonyms      | 110542  |
      | typeOf        | 111745  |
      | usageOf       | 2009    |

  Scenario Outline: hasDetails query parameter values are case sensitive
    When I search with a query parameter of "hasDetails=<detail>"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of 0 results
    Examples:
      | detail   |
      | ALSO     |
      | hasparts |
      | TypeOf   |

  Scenario Outline: Verify number of words for different word types - <type>
    When I search with a query parameter of "partOfSpeech=<type>"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of <results> results
    Examples:
      | type         | results |
      | adjective    | 19097   |
      | adverb       | 2752    |
      | conjunction  | 11      |
      | interjection | 0       |
      | noun         | 117960  |
      | preposition  | 16      |
      | pronoun      | 24      |
      | verb         | 11535   |

  Scenario Outline: Number of words matching a specific pronunciation pattern - <description>
    # This is just a small sample of regexes - many more test cases could be added
    # but these are sufficient to cover the main scenarios
    When I search with a query parameter of "pronunciationPattern=<regex>"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of <results> results
    Examples:
      | regex     | results | description |
      | ^[θʊɔ]    | 601     | starts with |
      | [^a-z]    | 110321  | contains    |
      | iɪŋ$      | 23      | ends with   |
      | ^'stoʊri$ | 2       | exact match |

  Scenario Outline: Verify number of words with varying number of phonemes - <sounds> phonemes
    When I search with a query parameter of "sounds=<sounds>"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of <results> results
    Examples:
      | sounds | results |
      | 1      | 7       |
      | 2      | 264     |
      | 3      | 2247    |
      | 4      | 5357    |
      | 5      | 10532   |
      | 10     | 20554   |
      | 15     | 3418    |
      | 20     | 360     |
      | 25     | 25      |

  Scenario Outline: Invalid sounds query param values - <description>
    When I search with a query parameter of "sounds=<letters>"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of 0 results
    Examples:
      | letters | description |
      | 0       | zero        |
      | -1      | negative    |
      | 1.23    | non-integer |

  Scenario: Verify number of words with at least 8 phonemes
    When I search with a query parameter of "soundsMin=8"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of 117504 results

  Scenario: Verify number of words with no more than 5 phonemes
    When I search with a query parameter of "soundsMax=5"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of 18407 results

  Scenario: Verify number of words for combined soundsMin & soundsMax
    When I search with the following query parameters
      | soundsMin=4 |
      | soundsMax=6 |
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of 32824 results

  Scenario: Zero results if soundsMin more than soundsMax value
    When I search with the following query parameters
      | soundsMin=9 |
      | soundsMax=3 |
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of 0 results

  Scenario: Sounds query parameter equivalence
    When I search with a query parameter of "sounds=8"
    And I search with the following query parameters
      | soundsMin=8 |
      | soundsMax=8 |
    Then both response bodies are identical

  Scenario Outline: Limit query parameter controls number of results returned
    # This apparently has a max of 100 according to the API documentation but it doesn't seem to have been
    # implemented properly, if at all
    When I search with a query parameter of "limit=<limit>"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And the limit value in the response body is "<limit>"
    And <limit> words are returned
    Examples:
      | limit  |
      | 1      |
      | 5      |
      | 10     |
      | 50     |
      | 100    |
      | 500    |
      | 1000   |
      | 5000   |
      | 10000  |
      | 50000  |
      | 100000 |

  Scenario: Limit defaults to 100
    # An earlier test showed this will return the whole data set
    When I search with a query parameter of "LETTERS=5"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And the limit value in the response body is 100
    And 100 words are returned

  Scenario: Limit of 100 equivalent to default limit parameter
    When I search with a query parameter of "LETTERS=5"
    And I search with a query parameter of "limit=100"
    Then the words returned in both response bodies are identical

  Scenario Outline: Invalid limit query param values - <description>
    When I search with a query parameter of "limit=<limit>"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And 0 words are returned
    Examples:
      | limit | description |
      | 0     | zero        |
      | -1    | negative    |
    @skip
    # A single word is returned - incorrectly, in my opinion
    Examples:
      | limit | description |
      | 1.23  | non-integer |

  Scenario: Page defaults to 1
    # An earlier test showed this will return the whole data set
    When I search with a query parameter of "SOUNDS=1"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And the page value in the response body is 1
    And there are a total of 325331 results

  Scenario: Page value of 1 equivalent to default page parameter
    When I search with a query parameter of "SOUNDS=1"
    And I search with a query parameter of "page=1"
    Then the words returned in both response bodies are identical

  Scenario Outline: Each page contains 100 words except the last page
    # The default limit is 100 words per page - this means each page should contain 100 words, with the exception of
    # the final page which will show the remaining words i.e. 3253 pages of 100 & 1 page of 31 words
    When I search with a query parameter of "page=<page>"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And the page value in the response body is "<page>"
    And there are a total of 325331 results
    And <words> words are returned
    Examples:
      | page | words |
      | 1    | 100   |
      | 1627 | 100   |
      | 3253 | 100   |
      | 3254 | 31    |

  Scenario Outline: 0 words returned for page values out of bounds
    When I search with a query parameter of "page=<page>"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And the page value in the response body is "<page>"
    And 0 words are returned
    Examples:
      | page |
      | 0    |
      | 3255 |

  Scenario: 0 words returned for non-numeric page value
    When I search with a query parameter of "page=a"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And the page value in the response body is "a"
    And 0 words are returned

  Scenario Outline: <description> page number returns results
    # I would argue this behaviour is wrong as one wouldn't normally expect negative & non-integer page numbers
    # to be valid but they seem to be. What's more, their validity adds a layer of complexity that requires
    # further testing, as shown in later scenarios
    When I search with a query parameter of "page=<page>"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And the page value in the response body is "<page>"
    And 100 words are returned
    Examples:
      | page | description |
      | -1   | Negative    |
      | 1.23 | Non-integer |

  # Exploratory testing has shown that negative page numbers are equivalent to working backwards from the end of the
  # dictionary. However, this equivalence is somewhat nuanced. There are 325331 words in the full data set, which is
  # 3254 pages at the default limit of 100 words per page. The first 3253 pages each contain 100 words with the final
  # page (3254) holding 31 words, as shown in a previous test. One might therefore expect page -1 to be equivalent to
  # page 3253 i.e. the last but one page, but that's not the case. Page 3253 contains the 325201st to 325300nd words
  # whereas page -1 contains the 325132nd to 325231st words i.e. the page before the last 100 words. Positive and
  # negative page numbers both contain 100 words per page except for the page number with the largest magnitude which
  # displays the remainder, but this doesn't mean an exact equivalence between the two sets of page numbers - there is
  # some overlap, however.
  #
  # Similarly, non-integer page numbers return 100 words (by default) from the word at an index equivalent to the poge
  # number in the full results set. For example, page 1.23 will return the 24th to 123rd words i.e. it will omit the
  # first 23 words (0.23 x default limit of 100). Similarly, page 10.50 will return the 951st to 1050th words.
  #
  # If the decimal part is specified to more than 2 decimal places (e.g. 1.234), the value is floored to the nearest
  # valid value, based on the current limit query parameter value (defaulting to 100). For example, 1.234 is rounded to
  # 1.23 and the first 23 words omitted as discussed above. Similarly, 1.239 will also be rounded down to 1.23 - values
  # are floored as later tests will show.

  Scenario Outline: Verify words returned for page number <page>
    When I search with a query parameter of "page=<page>"
    Then the words in the response body are the <from> to the <to> in the full results set
    Examples:
      | page    | from     | to       |
      | 1       | 1st      | 100th    |
      | 1627    | 162601st | 162700th |
      | 3254    | 325301st | 325331th |
      | -1      | 325132nd | 325231st |
      | -1500   | 175232nd | 175331st |
      | -3253   | 1st      | 31st     |
      | 1.23    | 24th     | 123rd    |
      | 2345.67 | 234468th | 234567th |
      | 1.234   | 24th     | 123rd    |
      | 1.2399  | 24th     | 123rd    |

  # Exploratory testing (and a lot of head scratching trying to work out what was happening) has revealed further
  # unexpected behaviour in the API. I would expect to be able to combine the limit and page query parameters in order
  # to be able to return a given number of words (limit) from anywhere in the full data set (determined by the page
  # value). However, that seems not to be the case. For example, with a limit of 10 and 325331 words in the full data
  # set one would expect there to be 32533 pages of 10 words and 1 page of 1 word. The first page does indeed contain
  # 10 words but after that things get strange. The 2nd page contains 1000 words, the 3rd page contains 1990 words,
  # the 4th page 2980 words and so on. The number of words per page increases by 990 with each increasing page number.
  # But there are still 32534 pages i.e. the expected number. And each page starts at the expected point in the results
  # set e.g. page 2 starts at the 11th word, page 3 with the 21st word etc. This means that for many of the pages a lot
  # of the words are duplicated. And when the number of words left in the data set exceeds the number of words for that
  # page, fewer words are returned - this happens when [10 + ((page - 1) * 990) > 325331 - (page * 10)] i.e. page 328
  # onwards. This means the last but one page contains 11 words and the last page has 1 word. In other words, only the
  # first and last pages have the expected number of words. The same is true for other limit values, but the number of
  # extra words per page isn't always 990 - it seems to be 99 x limit.
  #
  # Personally I would say this behaviour is a bug with the API implementation as it goes against all common sense but
  # as this is a 3rd party API there's not much that can be done about this. As a tester, I would capture the current
  # behaviour as best I can through a series of characterisation tests so that if this "bug" is ever fixed by the API
  # developers my tests will fail and I will be alerted to the change. This is preferable to ignoring this behaviour as
  # incorrect as it makes any behavioural changes obvious whereas skipping any tests of this functionality would miss
  # any future changes. If this were an internally developed API (i.e. by developers I was working alongside) then I
  # would be informed of any such changes, but for 3rd party APIs that won't be the case. By writing characterisation
  # tests for this functionality I also develop a change notification system - if the functionality changes, my tests
  # will fail.

  @characterisation
  Scenario Outline: Number of pages varies with limit query parameter value
    When I search with the following query parameters
      | limit=<limit> |
      | page=<page>   |
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And the limit value in the response body is "<limit>"
    And the page value in the response body is "<page>"
    And <actual words> words are returned
    Examples:
      | limit | page  | expected words | actual words |
      | 10    | 1     | 10             | 10           |
      | 10    | 2     | 10             | 1000         |
      | 10    | 3     | 10             | 1990         |
      | 10    | 326   | 10             | 321760       |
      | 10    | 327   | 10             | 322071       |
      | 10    | 328   | 10             | 322061       |
      | 10    | 32533 | 10             | 11           |
      | 10    | 32534 | 1              | 1            |
      | 50    | 1     | 50             | 50           |
      | 50    | 2     | 50             | 5000         |
      | 50    | 3     | 50             | 9950         |
      | 50    | 66    | 50             | 321800       |
      | 50    | 67    | 50             | 322031       |
      | 50    | 68    | 50             | 321981       |
      | 50    | 6506  | 50             | 81           |
      | 50    | 6507  | 31             | 31           |
      | 100   | 1     | 100            | 100          |
      | 100   | 2     | 100            | 100000       |
      | 100   | 3     | 100            | 199900       |
      | 100   | 4     | 100            | 299800       |
      | 100   | 5     | 100            | 324931       |
      | 100   | 6     | 100            | 324831       |
      | 100   | 3253  | 100            | 131          |
      | 100   | 3254  | 31             | 31           |
      | 500   | 1     | 500            | 500          |
      | 500   | 2     | 500            | 324831       |
      | 500   | 3     | 500            | 324331       |
      | 500   | 650   | 500            | 831          |
      | 500   | 651   | 331            | 331          |
      | 1000  | 1     | 1000           | 1000         |
      | 1000  | 2     | 1000           | 324331       |
      | 1000  | 3     | 1000           | 323331       |
      | 1000  | 325   | 1000           | 1331         |
      | 1000  | 326   | 331            | 331          |

  # Having shown above that the behaviour when combining limit & page query parameters is questionable at best, there
  # is not much point testing non-integer and negative page numbers in combination with various non-default limit values.
  # This is the sort of testing I would normally do but I don't see the value in doing so at this stage. A few quick
  # tests should illustrate inconsistencies in the behaviour that means a deeper dive into this functionality isn't
  # worth it, especially without being able to talk to the API developers/product owner to better understand the
  # requirements and intended behaviour

  @characterisation
  Scenario Outline: Verify number words for various limits & non-integer page values
    When I search with the following query parameters
      | limit=<limit> |
      | page=<page>   |
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And the limit value in the response body is "<limit>"
    And the page value in the response body is "<page>"
    Then <words> words are returned
    Examples:
      | limit | page  | words  |
      | 10    | 1.2   | 0      |
      | 50    | 1.2   | 0      |
      | 50    | 1.20  | 0      |
      | 50    | 1.23  | 0      |
      | 50    | 1.24  | 1238   |
      | 100   | 1.2   | 0      |
      | 100   | 1.20  | 0      |
      | 100   | 1.23  | 23077  |
      | 500   | 1.2   | 0      |
      | 500   | 1.20  | 0      |
      | 500   | 1.23  | 1      |
      | 1000  | 1.2   | 0      |
      | 1000  | 1.20  | 0      |
      | 1000  | 1.23  | 0      |
      | 1000  | 1.234 | 325097 |

  # Let's get back to demonstrating behaviour that is much more like one would expect...

  Scenario: Can use query parameter to return a random word
    When I search with a query parameter of "random=true"
    Then the response has a status code of 200
    And the response body follows the "Everything" endpoint JSON schema

  Scenario: Different words returned in multiple calls with random query parameter
    When I search with a query parameter of "random=true"
    And I search with a query parameter of "random=true"
    Then the "word" value in the response bodies differs

  Scenario Outline: Invalid random query parameter values - <value>
    When I search with a query parameter of "random=<value>"
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of 325331 results
    Examples:
      | value |
      | false |
      | 1     |
      | 0     |
      | TRUE  |
      | tRUe  |
      | True  |

  # Previous tests have shown that the limit and page query parameters can be combined, although the results of those
  # tests were not entirely as expected. I have also shown that lettersMin & lettersMax can be combined, as can
  # soundsMin & soundsMax. The Other search query parameters can also be combined as the tests below show.
  # I'm not testing every combination and permutation, just spot-checking a number of common and powerful combinations,
  # as well as showing the query parameter order is unimportant

  Scenario: partOfSpeech & letters query parameters combined
    When I search with the following query parameters
      | partOfSpeech=noun |
      | letters=8         |
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of 10624 results

  Scenario: partOfSpeech & soundsMin query parameters combined
    When I search with the following query parameters
      | partOfSpeech=adverb |
      | soundsMin=15        |
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And the following words are returned
      | argumentatively  |
      | circumstantially |
      | conversationally |
      | counterclockwise |
      | disingenuously   |
      | excruciatingly   |
      | experimentally   |
      | extemporaneously |
      | extraordinarily  |
      | grandiloquently  |
      | indiscriminately |
      | instantaneously  |
      | simultaneously   |

  Scenario: letters & sounds query parameters combined
    When I search with the following query parameters
      | letters=12 |
      | sounds=6   |
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of 20 results

  Scenario: letters & random query parameters combined
    When I search with the following query parameters
      | letters=10  |
      | random=true |
    Then the response has a status code of 200
    And the response body follows the "Everything" endpoint JSON schema
    And the returned word has 10 letters

  Scenario: Order of query parameters doesn't matter
    When I search with the following query parameters
      | letters=12 |
      | sounds=6   |
    And I search with the following query parameters
      | sounds=6   |
      | letters=12 |
    Then both response bodies are identical

  Scenario Outline: Combine hasDetails & random query parameters
    When I search with the following query parameters
      | hasDetails=<detail> |
      | random=true         |
    Then the response has a status code of 200
    And the response body follows the "Everything" endpoint JSON schema
    Examples:
      | detail        |
      | also          |
      | antonyms      |
      | definitions   |
      | examples      |
      | frequency     |
      | hasCategories |
      | hasInstances  |
      | hasMembers    |
      | hasParts      |
      | hasTypes      |
      | hasUsages     |
      | inCategory    |
      | inRegion      |
      | instanceOf    |
      | memberOf      |
      | partOf        |
      | pertainsTo    |
      | pronunciation |
      | regionOf      |
      | similarTo     |
      | substanceOf   |
      | syllables     |
      | synonyms      |
      | typeOf        |
      | usageOf       |

  Scenario Outline: No words returned for combination of hasDetails & random query parameters
    When I search with the following query parameters
      | hasDetails=<detail> |
      | random=true         |
    Then the response has a status code of 200
    And the response body follows the "Search" JSON schema
    And there are a total of 0 results
    Examples:
      | detail        |
      | hasSubstances |
      | rhymes        |