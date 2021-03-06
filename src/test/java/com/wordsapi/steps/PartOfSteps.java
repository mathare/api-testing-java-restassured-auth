package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class PartOfSteps {
    private static final String FIELD = "partOf";

    @Then("^the (?:word|phrase) is a part of the following$")
    public void verifyPartsAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), equalTo(dataTable.asList()));
    }

    @Then("the word is not a part of anything")
    public void verifyPartOfArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }

    @Then("the word is a part of {int} things")
    public void verifyNumThingsPartOf(int numThings) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), hasSize(numThings));
    }
}
