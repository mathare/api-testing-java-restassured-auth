package com.wordsapi.steps;

import io.cucumber.java.Before;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.config.RestAssuredConfig;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import org.apache.commons.lang3.NotImplementedException;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import static io.restassured.config.HeaderConfig.headerConfig;
import static io.restassured.module.jsv.JsonSchemaValidator.matchesJsonSchema;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

public class CommonSteps {

    private static final String BASE_RESOURCES_DIR = "src/test/resources/";
    private static final String SCHEMAS_DIR = BASE_RESOURCES_DIR + "schemas/";
    private static final String EXPECTED_RESPONSES_DIR = BASE_RESOURCES_DIR + "expectedResponses/";
    private static final List<String> ENDPOINTS = Arrays.asList("Antonyms", "Definitions", "Everything", "Examples",
            "Frequency", "Has Instances", "Has Parts", "Has Types", "In Region", "Instance Of", "Part Of", "Region Of",
            "Rhymes", "Synonyms", "Type Of");
    private static final List<String> PARTS_OF_SPEECH = Arrays.asList("adjective", "adverb", "noun", "preposition", "pronoun", "verb");
    static Response response;
    static List<Response> responses;
    private static RequestSpecification request;
    private static String endpoint, word;

    @Before
    public static void setup() {
        RestAssured.baseURI = "https://wordsapiv1.p.rapidapi.com/words/";
        request = RestAssured.given();
        request.header("Content-Type", "application/json");
        responses = new ArrayList<>();
    }

    @When("^I make a (GET|PATCH|POST|PUT|DELETE) request to the \"(.*)\" endpoint for the (?:word|phrase) \"(.*)\"")
    public static void makeRequest(String requestType, String endpoint, String word) {
        if (ENDPOINTS.contains(endpoint)) {
            CommonSteps.endpoint = endpoint;
            CommonSteps.word = word;
            request.config(RestAssuredConfig.config().headerConfig(headerConfig().overwriteHeadersWithName("x-rapidapi-key")));
            request.header("x-rapidapi-key", System.getProperty("API_KEY"));
            switch (requestType) {
                case "GET":
                    response = request.get(buildRequestURI(word, endpoint));
                    break;
                case "PATCH":
                    response = request.patch(buildRequestURI(word, endpoint));
                    break;
                case "POST":
                    response = request.post(buildRequestURI(word, endpoint));
                    break;
                case "PUT":
                    response = request.put(buildRequestURI(word, endpoint));
                    break;
                case "DELETE":
                    response = request.delete(buildRequestURI(word, endpoint));
                    break;
            }
            responses.add(response);
        } else {
            throw new NotImplementedException("Invalid API endpoint");
        }
    }

    @When("^I make a GET request without an API key header to the \"(.*)\" endpoint for the word \"(.*)\"")
    public static void makeUnauthorisedRequestNoAPIKeyHeader(String endpoint, String word) {
        if (ENDPOINTS.contains(endpoint)) {
            response = request.get(buildRequestURI(word, endpoint));
            responses.add(response);
        } else {
            throw new NotImplementedException("Invalid API endpoint");
        }
    }

    @When("^I make a GET request with an invalid API key header to the \"(.*)\" endpoint for the word \"(.*)\"")
    public static void makeUnauthorisedRequestInvalidAPIKeyHeader(String endpoint, String word) {
        if (ENDPOINTS.contains(endpoint)) {
            request.config(RestAssuredConfig.config().headerConfig(headerConfig().overwriteHeadersWithName("x-rapidapi-key")));
            request.header("invalid-api-key-header", System.getProperty("API_KEY"));
            response = request.get(buildRequestURI(word, endpoint));
            responses.add(response);
        } else {
            throw new NotImplementedException("Invalid API endpoint");
        }
    }

    @When("^I make a GET request with an invalid API key value to the \"(.*)\" endpoint for the word \"(.*)\"")
    public static void makeUnauthorisedRequestInvalidAPIKeyValue(String endpoint, String word) {
        if (ENDPOINTS.contains(endpoint)) {
            request.config(RestAssuredConfig.config().headerConfig(headerConfig().overwriteHeadersWithName("x-rapidapi-key")));
            request.header("x-rapidapi-key", "1234567890");
            response = request.get(buildRequestURI(word, endpoint));
            responses.add(response);
        } else {
            throw new NotImplementedException("Invalid API endpoint");
        }
    }

    @Then("the response has a status code of {int}")
    public static void verifyResponseStatusCode(int code) {
        assertThat(response.getStatusCode(), equalTo(code));
    }

    @Then("^the response body follows the (expected|error) JSON schema$")
    public static void verifyResponseBodyAgainstJsonSchema(String type) {
        assertThat(response.asString(), type.equals("error") ?
                matchesJsonSchema(getJsonSchema("Error")) :
                matchesJsonSchema(getJsonSchema(endpoint)));
    }

    @Then("the response body matches the expected response")
    public static void verifyResponseBodyAgainstExpectedResponse() {
        Object expectedResponse = getExpectedResponse(endpoint, word);
        assertThat(JsonPath.from(response.asString()).get(), equalTo(expectedResponse));
    }

    @Then("the response body contains an error message of {string}")
    public static void verifyResponseBodyErrorMessage(String expectedMessage) {
        assertThat(JsonPath.from(response.asString()).get("message"), equalTo(expectedMessage));
    }

    @Then("the word field in the response body is {string}")
    public static void verifyWord(String word) {
        assertThat(JsonPath.from(response.asString()).get("word"), equalTo(word));
    }

    @Then("all response bodies are identical")
    public static void verifyAllResponsesIdentical() {
        for (int i = 1; i < responses.size(); i++) {
            assertThat(responses.get(i).asString(), equalTo(responses.get(0).asString()));
        }
    }

    @Then("^(\\d+) of the definitions (?:are|is (?:a|an)) (\\w+)$")
    public static void verifyPartsOfSpeech(int occurrences, String partOfSpeech) {
        if (partOfSpeech.endsWith("s")) partOfSpeech = partOfSpeech.substring(0, partOfSpeech.length() - 1);
        if (PARTS_OF_SPEECH.contains(partOfSpeech)) {
            int count = 0;
            List<Map<String, String>> results = new ArrayList<>();
            if (endpoint.equals("Everything")) {
                results = JsonPath.from(response.asString()).get("results");
            } else if (endpoint.equals("Definitions")) {
                results = JsonPath.from(response.asString()).get("definitions");
            }
            for (Map<String, String> result : results) {
                if (result.get("partOfSpeech") != null && result.get("partOfSpeech").equals(partOfSpeech)) count++;
            }
            assertThat(count, equalTo(occurrences));
        } else {
            throw new NotImplementedException("Unknown part of speech: " + partOfSpeech);
        }
    }

    private static String formatEndpoint(String endpoint) {
        return endpoint.replaceAll(" ", "").toLowerCase();
    }

    private static String buildRequestURI(String word, String endpoint) {
        return endpoint.equals("Everything") ? word.toLowerCase() : (word + "/" + formatEndpoint(endpoint)).toLowerCase();
    }

    private static File getJsonSchema(String schemaName) {
        return new File(SCHEMAS_DIR + schemaName.replaceAll(" ", "") + "Schema.json");
    }

    private static Object getExpectedResponse(String endpoint, String word) {
        word = word.substring(0, 1).toUpperCase() + word.substring(1);
        String filename = EXPECTED_RESPONSES_DIR + formatEndpoint(endpoint) + "/" + word + "Response.json";
        return JsonPath.from(new File(filename)).get();
    }
}