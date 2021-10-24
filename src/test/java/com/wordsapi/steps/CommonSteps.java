package com.wordsapi.steps;

import io.cucumber.java.Before;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import static io.restassured.module.jsv.JsonSchemaValidator.matchesJsonSchema;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

public class CommonSteps {

    private static final String BASE_RESOURCES_DIR = "src/test/resources/";
    private static final String SCHEMAS_DIR = BASE_RESOURCES_DIR + "schemas/";
    private static final String EXPECTED_RESPONSES_DIR = BASE_RESOURCES_DIR + "expectedResponses/";

    private static RequestSpecification request;
    public static Response response;
    private static List<Response> responses;
    private static String endpoint, word;

    @Before
    public void setup() {
        RestAssured.baseURI = "https://wordsapiv1.p.rapidapi.com/words/";
        request = RestAssured.given();
        request.header("x-rapidapi-key", System.getProperty("API_KEY"));
        request.header("Content-Type", "application/json");
        responses = new ArrayList<>();
    }


    @When("^I make a GET request to the \"(.+)\" endpoint for the word \"(.+)\"$")
    public void makeRequest(String endpoint, String word) {
        CommonSteps.endpoint = endpoint;
        CommonSteps.word = word;
        response = request.get(buildRequestURI(word, endpoint));
        responses.add(response);
    }

    @Then("the response has a status code of {int}")
    public void verifyResponseStatusCode(int code) {
        assertThat(response.getStatusCode(), equalTo(code));
    }

    @Then("the response body follows the {string} JSON schema")
    public void verifyResponseBodyAgainstJsonSchema(String schemaName) {
//        String filename = SCHEMAS_DIR + schema.replaceAll(" ", "") + "Schema.json";
//        assertThat(response.asString(), matchesJsonSchema(new File(filename)));
        assertThat(response.asString(), matchesJsonSchema(getJsonSchema(schemaName)));
    }

    @Then("the response body matches the expected response")
    public void verifyResponseBodyAgainstExpectedResponse() {
//        String filename = EXPECTED_RESPONSES_DIR + expectedResponse.replaceAll(" ", "") + "Response.json";
//        Object expected = JsonPath.from(new File(filename)).get();
        Object expectedResponse = getExpectedResponse(endpoint, word);
        assertThat(JsonPath.from(response.asString()).get(), equalTo(expectedResponse));
    }

    private String buildRequestURI(String word, String endpoint) {
        return (word + "/" + endpoint.replace(" ", "")).toLowerCase();
    }

    private File getJsonSchema(String schemaName) {
        return new File(SCHEMAS_DIR + schemaName.replaceAll(" ", "") + "Schema.json");
    }

    private Object getExpectedResponse(String endpoint, String word) {
        endpoint = endpoint.replaceAll(" ", "").toLowerCase();
        word = word.substring(0, 1).toUpperCase() + word.substring(1);
        String filename = EXPECTED_RESPONSES_DIR + endpoint + "/" + word + "Response.json";
        return JsonPath.from(new File(filename)).get();
    }
}
