package com.typicode.jsonplaceholder.steps;

import com.typicode.jsonplaceholder.helpers.RequestHelpers;
import io.cucumber.java.Before;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.response.Response;

import java.util.ArrayList;
import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

public class CommonSteps {

    public static Response response;
    public static List<Response> responses;

    @Before
    public static void setup() {
        responses = new ArrayList<>();
    }

    @When("^I make a GET request to the \"(.+)\" endpoint for the word \"(.+)\"$")
    public static void makeRequest(String endpoint, String word) {
        endpoint = endpoint.toLowerCase().replace(" ", "");
        response = RequestHelpers.sendGetRequest(endpoint, word);
        responses.add(response);
    }

    @Then("the response has a status code of {int}")
    public static void verifyResponseStatusCode(int code) {
        assertThat(response.getStatusCode(), equalTo(code));
    }
}
