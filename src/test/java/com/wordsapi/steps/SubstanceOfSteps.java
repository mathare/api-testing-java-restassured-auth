package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class SubstanceOfSteps {
    private static final String FIELD = "substanceOf";

    @Then("^the (?:word|phrase) is a substance of the following$")
    public void verifyAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), equalTo(dataTable.asList()));
    }

    @Then("the word is not a substance of anything")
    public void verifySubstanceOfArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }

    @Then("the word is a substance of {int} things")
    public void verifyNumThingsSubstanceOf(int numThings) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), hasSize(numThings));
    }
}
