package com.wordsapi.steps;

import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

public class PronunciationSteps {
    private static final String FIELD = "pronunciation";

    @Then("the word has no pronunciation specified")
    public void verifyPronunciationEmpty() {
        if (response.asString().contains("pronunciation")) {
            assertThat(JsonPath.from(response.asString()).get(FIELD).toString(), equalTo("{}"));
        }
    }

    @Then("^the (adjective|noun|verb) form of the word is pronounced \"(.*)\"$")
    public void verifyNumRhymes(String wordForm, String pronunciation) {
        assertThat(JsonPath.from(response.asString()).get(FIELD + "." + wordForm), equalTo(pronunciation));
    }
}