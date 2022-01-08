[![Continuous Integration Status](https://github.com/mathare/api-testing-java-restassured-auth/actions/workflows/ci.yml/badge.svg)](https://github.com/mathare/api-testing-java-restassured-auth/actions)

# Testing REST API Requiring Authorisation with Java & RestAssured

## Overview
This project provides an example of how to use Cucumber BDD feature files with step definitions written in Java and calling the RestAssured library to automate testing of a RESTful API that requires calls to be authorised with an API key. Therefore the project demonstrates an alternative to automated API testing with Postman. 

Unlike other automated API testing projects I have created (e.g. [Java HTTP Client](https://github.com/mathare/api-testing-java-httpclient), [Java RestAssured](https://github.com/mathare/api-testing-java-restassured)), this **is** intended to be a complete implementation of a test suite for the target API, or at least as complete as possible. As such, this project is not intended to act as a kickstarter project, unlike those previously mentioned, and instead is an example of (a) how to make authorised calls using RestAssured and (b) how to fully test an API. 

NB There is no published requirements spec for the API so I can't claim this is a **complete** test suite with full coverage but it is a detailed set of tests providing extensive coverage of all API endpoints.

## Why Use RestAssured?
RestAssured is an open source Java-based library that provides a domain-specific language for writing powerful automated tests for RESTful APIs. Despite it being one of the most popular API testing libraries for Java, I don't have much prior experience with it having used HTTP Client more extensively so this project was an opportunity to become more familiar with RestAssured, and in particular how it is applies to APIs that require authorisation.

Most RestAssured examples seem to heavily use the `given()`, `when()` and `then()` methods, which I find makes the steps more confusing when one is also using Cucumber BDD. Therefore I have opted to steer clear of using these methods as much as possible, which means my code may differ from the way more experienced RestAssured practitioners would do things. I have tried to make my RestAssured calls succint but clear and obvious as to what they do. 

As RestAssured has a dependency on Hamcrest I have used Hamcrest assertions throughout this project rather than the JUnit assertions I am more familiar with so that things are done in the typical RestAssured style. I have also favoured RestAssured methods for creating JSON objects instead of using external JSON libraries I have used in my HTTP Client projects.

## API Under Test
The REST API being tested by this project is the [Words API](https://www.wordsapi.com/), a simple third-party API that can be used to find definitions, synonyms, rhymes etc for words. As such the API can be used to power dictionaries, thesauruses and more. 

I chose the Words API as it requires all API calls to be authorised via an API key in the request headers, allowing me to gain experience of using RestAssured for making authorised calls. The API follows the freemium model - it has a rate-limited (in terms of calls per day) free tier plus paid tiers with significantly larger numbers of allowed calls per day. I am using the free tier, which limits my usage to 2500 API calls per day. The free tier requires the user to sign up and create an API key, which I have done. The API key is stored in the GitHub project secrets as API_KEY and retrieved when needed in the test code via `System.getProperty("API_KEY")`

NB If you clone this repo, the tests will not run unless a valid API key is created and stored in the project secrets as API_KEY.

### Endpoints

The Words API has many endpoints, each of which returns different information about the word passed in as part of the request. The main endpoints are:
* **definitions** - the meaning of the word, including its part of speech (noun, verb etc.)
* **pronunciation** - how the word is pronounced, using the [International Phonetic Alphabet](https://en.wikipedia.org/wiki/International_Phonetic_Alphabet). The response may include multiple key-value pairs if the word is pronounced differently depending on the part of speech it is used as
* **syllables** - the total number of syllables in the word plus a breakdown of those syllables
* **synonyms** - words with the same meaning as the original word in the same context
* **antonyms** - words with the opposite meaning to the original word
* **examples** - example sentences using the word
* **rhymes** - words that rhyme with the specified word. Where the original word can be pronounced differently when used as different parts of speech, the response will include separate arrays of rhyming words
* **frequency** - three frequency values reflecting how often the word is used. The values are zipf (a log10 number, the higher the value the more frequent the word is used), perMillion (the number of times the word is likely to appear in any English corpus, per million words) and diversity (a value in the range 0-1 representing how likely it is the word will appear in a document that is part of a corpus)
* **typeOf** - words that are more generic than the original word (hypernyms). For example, a hatchback is a type of car
* **hasTypes** - words that are more specific than the original word (hyponyms). For example, purple has types of lavender, mauve etc.
* **partOf** - the larger whole to which the word belongs (holonyms). For example, a finger is a part of a glove, hand etc.
* **hasParts** - words that are part of the original word (meronyms). For example, a building has parts such as roof, walls etc.
* **instanceOf** - words that the original word is an example of. For example, Einstein is a physicist
* **hasInstances** - words that are examples of the original word. For example, search engine has instances of google, yahoo etc.
* **similarTo** - words that are similar to, but not synonyms of, the original word. For example, red is similar to bloody
* **also** - phrases to which the word belongs. For example, bump is used in the phrase bump off
* **entails** - words that are implied by the original word. This endpoint is usually used for verbs. For example, rub entails touch
* **memberOf** - a group to which the original word belongs. For example, dory is a member of the family zeidae
* **hasMembers** - words that belong to the group defined by the original word. For example, a cult has members called cultists
* **substanceOf** - substances of which the original word is a part. For example, water is a substance of sweat
* **hasSubstances** - substances that are part of the original word. For example, wood has a substance of lignin
* **inCategory** - the domain category to which the original word belongs. For example, chaotic is in the category of physics
* **hasCategories** - categories of the original word. For example, science has categories such as biology, chemistry, physics etc.
* **usageOf** - words that the original word is a domain usage of. For example, Coca-Cola is a usage of trademark
* **hasUsages** - words that are examples of the domain the original word defines. For example, colloquialism has usages including big deal, blue moon etc.
* **inRegion** - regions where the word is used. For example, social security number is used in the United States
* **regionOf** - a region where words are used. For example, Hawaii is the region of luau, mahimahi etc.
* **pertainsTo** - words to which the original word is relevant. For example, terrestrial pertains to earth

One can also make calls without specifying an endpoint, which will return all stored details for the specified word i.e. definition, examples, pronunciation etc in a single object.

The API also supports searching via the following query parameters:
* **letterPattern** - find words whose letters match a given regular expression
* **letters** - find words of a specified length
* **lettersMin** - find words with at least the specified number of letters
* **lettersMax** - find words whose length is no more than the specified number of letters
* **pronunciationPattern** - find words whose pronunciation matches a given regular expression
* **sounds** - find words with a specified number of sounds, based on the IPA phonemes
* **soundsMin** - find words with at least the specified number of sounds
* **soundsMax** - find words with no more than the specified number of sounds
* **partOfSpeech** - find all words matching the specified part of speech (e.g. verb, noun etc.)
* **limit** - the maximum number of results to return in the request
* **page** - the page of results to return

Random words can also be returned by appending a query parameter of `random=true`.

Unlike the [JSON Placeholder](https://jsonplaceholder.typicode.com) API I have used in other API testing projects, the Words API is backed by a real database. However, the API is intended for read-only use so words cannot be added to or deleted from the database via API calls, as shown in the tests.

## Test Framework
As stated above, this project contains a Java test framework suitable for REST APIs and utilises Cucumber BDD. The use of Cucumber means the tests themselves are clean and clear, written in plain English, so they can be understood by anyone working with the project, including non-technical roles. 

While this project is an example of a full Java testing solution for an API, it has been developed in isolation by a single user (me). I have not had access to the API developers to be able to confirm certain aspects of the behaviour, for example, so have made extensive use of exploratory testing to establish how the API behaves. As a result, the project includes tests, especially in the Search feature, that I would not have written had I relied solely on the published API documentation as the observed behaviour differs from that described in the documentation. 

In a real-life project the tests would be developed alongside other engineers working on the API itself. As such, the use of BDD is essential for collaboration between QAs, developers, and business roles (e.g. Product Owners, Business Analysts etc) to help clear up any discrepancies between the observed and documented behaviours. Quality is everyone’s responsibility, which means the tests themselves need to be easily understood by all stakeholders.

### Tech Stack
As this is a Java project, build and dependency management is handled by Maven, so there is a `pom.xml` file defining the versions of the dependencies:
* Java v11
* Cucumber v6.11.0
* RestAssured v4.4.0

The code is written in Java and built using v11 of the JDK. There are more up-to-date JDK versions available  - Oracle is up to Java 17 at the time of writing. However, I used Amazon Coretto 11 (the latest LTS release of this popular OpenJDK build) as it is the distribution I am most used to.

The Cucumber version is the latest release of version 6 (released May 2021) that was available when this project was created. Version 7 has since been released but I have not yet had a chance to compare the latest version with the version used here to determine compatibility.

I have used the latest RestAssured version (released May 2021) available at the time of writing and as it has a dependency on Hamcrest I have used that as the assertion library. As RestAssured has built-in methods for schema validation, no further libraries are needed.

### Project Structure
The project uses a standard structure and naming convention, incorporating the URL of the website under test, i.e. the test code is all stored under `src/test/java/com/wordsapi`. Below that we have:
* `features`  - this folder contains the Cucumber `.feature` files, one per API endpoint. Each feature file is named after the endpoint it tests, e.g. `Definitions.feature` contains the tests for the Definitions endpoint. There is also an `Everything.feature` testing the behaviour when no endpoint is specified i.e. the response contains all details about the chosen word. An `EndpointEquivalence.feature` has been added to confirm that the responses from the individual endpoints match the equivalent part of the "everything" response. There is also a `Search.feature` covering the various search options.
* `steps` - a collection of classes containing the implementation of the steps from the Cucumber feature files. The main class is `CommonSteps.java` containing the implementation of the steps that would be used by more than one feature file, such as the steps to make the API requests, avoiding duplication of code across individual steps classes. There is also a steps class for each endpoint (e.g. `DefinitionSteps.java`) containing any specific steps for that endpoint, mostly response verification steps.  
* `TestRunner.java` - an empty test runner class, decorated with the annotations required to run Cucumber tests, including the `CucumberOptions` annotation which defines the location of the features and associated steps.

There is also a test resources folder `src/test/resources` containing a number of files against which responses can be verified. The folder is split as follows:
* `expectedResponses` - the expected reponse bodies of a number of requests are stored here as JSON files
* `schemas` -  JSON format schemas for each of the endpoints

### Running Tests
The tests are easy to run as they are bound to the Maven `test` goal so running the tests is as simple as executing `mvn test` within the directory in which the repo has been cloned. Alternatively, the empty `TestRunner` class can be executed using a JUnit runner within an IDE.

#### Test Reports
A report is generated for each test run, using the Cucumber `pretty` plugin to produce an HTML report called `cucumber-report.html` in the `target` folder. This is a simple report showing a summary of the test run (number of tests run, number passed/failed/skipped, duration, environment etc) above a breakdown of each individual feature file, showing the status of each scenario and the individual steps within that scenario, including a stack trace for failing steps. 

### CI Pipeline
This repo contains a CI pipeline implemented using [GitHub Actions](https://github.com/features/actions). Any push to the `main` branch or any pull request on the `main` branch will trigger the pipeline, which runs in a Linux VM on the cloud within GitHub. The pipeline consists of a single `run-tests` job which checks out the repo then runs the test suite via `mvn test`. Once the tests have finished, whether they pass or fail, a test report is uploaded as a GitHub artifact. At the end of the steps the environment tears itself down and produces a [status report](https://github.com/mathare/api-testing-java-restassured-auth/actions). Each status report shows details of the test run, including logs for each step and a download link for the test report artifact.

In addition to the automated triggers above, the CI pipeline has a manual trigger actionable by clicking "Run workflow" on the [Continuous Integration](https://github.com/mathare/api-testing-java-restassured-auth/actions/workflows/ci.yml) page. This allows the user to select the branch to run the pipeline on, so tests can be run on a branch without the need for a pull request. This option is only visible if you are the repo owner.