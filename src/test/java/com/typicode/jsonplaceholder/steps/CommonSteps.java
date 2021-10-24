package com.typicode.jsonplaceholder.steps;

import io.cucumber.java.Before;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;

import java.util.ArrayList;
import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

public class CommonSteps {

    private RequestSpecification request;
    private Response response;
    private List<Response> responses;

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
        this.endpoint = endpoint;
        this.word = word;
        response = request.get(buildRequestURI(word, endpoint));
        responses.add(response);
    }

    @Then("the response has a status code of {int}")
    public void verifyResponseStatusCode(int code) {
        assertThat(response.getStatusCode(), equalTo(code));
    }
    private String buildRequestURI(String word, String endpoint) {
        return (word + "/" + endpoint.replace(" ", "")).toLowerCase();
    }
}
