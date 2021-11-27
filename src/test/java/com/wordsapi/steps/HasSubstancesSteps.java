package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.empty;
import static org.hamcrest.Matchers.equalTo;

public class HasSubstancesSteps {
    private static final String FIELD = "hasSubstances";

    @Then("the word has the following substances")
    public void verifySubstancesAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), equalTo(dataTable.asList()));
    }

    @Then("the word has no substances")
    public void verifyHasSubstancesArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }
}
