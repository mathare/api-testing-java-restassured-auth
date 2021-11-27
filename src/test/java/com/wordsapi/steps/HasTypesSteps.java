package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class HasTypesSteps {
    private static final String FIELD = "hasTypes";

    @Then("^the (?:word|phrase) has the following types$")
    public void verifyTypesAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), equalTo(dataTable.asList()));
    }

    @Then("the word has no types")
    public void verifyHasTypesArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }

    @Then("^the (?:word|phrase) has (\\d+) types$")
    public void verifyNumTypes(int numTypes) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), hasSize(numTypes));
    }
}
