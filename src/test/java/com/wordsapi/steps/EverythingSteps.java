package com.wordsapi.steps;

import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;
import org.apache.commons.lang3.NotImplementedException;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.hasSize;

public class EverythingSteps {

    private static final List<String> PARTS_OF_SPEECH = Arrays.asList("adjective", "adverb", "definite article", "noun", "obj", "pl", "preposition", "pronoun", "verb");

    @Then("the response body contains {int} definition(s)")
    public void verifyNumDefinitions(int numDefinitions) {
        assertThat(JsonPath.from(response.asString()).get("results"), hasSize(numDefinitions));
    }

}
