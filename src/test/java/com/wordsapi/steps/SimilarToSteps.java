package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class SimilarToSteps {
    private static final String FIELD = "similarTo";

    @Then("^the (?:word|phrase) is similar to the following$")
    public void verifyAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), equalTo(dataTable.asList()));
    }

    @Then("the word isn't similar to anything")
    public void verifySimilarToArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }

    @Then("the word is similar to {int} things")
    public void verifyNumThingsSimilarTo(int numThings) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), hasSize(numThings));
    }
}
