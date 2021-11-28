package com.wordsapi.steps;

import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

public class SyllablesSteps {
    private static final String FIELD = "syllables";

    @Then("the word has no syllables")
    public void verifyNoSyllables() {
        assertThat(JsonPath.from(response.asString()).get(FIELD).toString(), equalTo("{}"));
    }
}
