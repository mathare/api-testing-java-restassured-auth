package com.wordsapi.steps;

import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static com.wordsapi.steps.CommonSteps.responses;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

public class EndpointEquivalenceSteps {

    @Then("the {string} field in both response bodies is identical")
    public void verifyEquivalence(String field) {
        List<List<String>> results = JsonPath.from(responses.get(0).asString()).get("results." + field);
        results.removeAll(Collections.singleton(null));
        List<String> actual = new ArrayList<>();
        for (List<String> result : results) {
            actual.addAll(result);
        }
        assertThat(JsonPath.from(responses.get(1).asString()).get(field), equalTo(actual));
    }
}
