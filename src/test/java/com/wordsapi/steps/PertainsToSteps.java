package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class PertainsToSteps {
    private static final String FIELD = "pertainsTo";

    @Then("the word pertains to the following")
    public void verifyAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), equalTo(dataTable.asList()));
    }

    @Then("the word pertains to nothing")
    public void verifyPertainsToArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }

    @Then("the word pertains to {int} things")
    public void verifyNumThingsPertainsTo(int numThings) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), hasSize(numThings));
    }
}
