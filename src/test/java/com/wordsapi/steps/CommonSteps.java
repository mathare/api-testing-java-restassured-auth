package com.wordsapi.steps;

import io.cucumber.java.Before;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import org.apache.commons.lang3.NotImplementedException;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static io.restassured.module.jsv.JsonSchemaValidator.matchesJsonSchema;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

public class CommonSteps {

    private static final String BASE_RESOURCES_DIR = "src/test/resources/";
    private static final String SCHEMAS_DIR = BASE_RESOURCES_DIR + "schemas/";
    private static final String EXPECTED_RESPONSES_DIR = BASE_RESOURCES_DIR + "expectedResponses/";
    public static Response response;
    private static RequestSpecification request;
    private static List<Response> responses;
    private static String endpoint, word;
    private static final List<String> ENDPOINTS = Arrays.asList("Everything", "Type Of");

    @Before
    public void setup() {
        RestAssured.baseURI = "https://wordsapiv1.p.rapidapi.com/words/";
        request = RestAssured.given();
        request.header("x-rapidapi-key", System.getProperty("API_KEY"));
        request.header("Content-Type", "application/json");
        responses = new ArrayList<>();
    }


    @When("I make a GET request to the {string} endpoint for the word {string}")
    public void makeRequest(String endpoint, String word) {
        if (ENDPOINTS.contains(endpoint)) {
            CommonSteps.endpoint = endpoint;
            CommonSteps.word = word;
            response = request.get(buildRequestURI(word, endpoint));
            responses.add(response);
        } else {
            throw new NotImplementedException("Invalid API endpoint");
        }
    }

    @Then("the response has a status code of {int}")
    public void verifyResponseStatusCode(int code) {
        assertThat(response.getStatusCode(), equalTo(code));
    }

    @Then("^the response body follows the (expected|error) JSON schema$")
    public void verifyResponseBodyAgainstJsonSchema(String type) {
        assertThat(response.asString(), type.equals("error") ?
                matchesJsonSchema(getJsonSchema("Error")) :
                matchesJsonSchema(getJsonSchema(endpoint)));
    }

    @Then("the response body matches the expected response")
    public void verifyResponseBodyAgainstExpectedResponse() {
        Object expectedResponse = getExpectedResponse(endpoint, word);
        assertThat(JsonPath.from(response.asString()).get(), equalTo(expectedResponse));
    }

    @Then("the response body contains an error message of {string}")
    public void verifyResponseBodyErrorMessage(String expectedMessage) {
        assertThat(JsonPath.from(response.asString()).get("message"), equalTo(expectedMessage));
    }

    private String formatEndpoint(String endpoint) {
        return endpoint.replaceAll(" ", "").toLowerCase();
    }

    private String buildRequestURI(String word, String endpoint) {
        return endpoint.equals("Everything") ? word.toLowerCase() : (word + "/" + formatEndpoint(endpoint)).toLowerCase();
    }

    private File getJsonSchema(String schemaName) {
        return new File(SCHEMAS_DIR + schemaName.replaceAll(" ", "") + "Schema.json");
    }

    private Object getExpectedResponse(String endpoint, String word) {
        word = word.substring(0, 1).toUpperCase() + word.substring(1);
        String filename = EXPECTED_RESPONSES_DIR + formatEndpoint(endpoint) + "/" + word + "Response.json";
        return JsonPath.from(new File(filename)).get();
    }
}
