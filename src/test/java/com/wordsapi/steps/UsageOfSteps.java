package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.empty;
import static org.hamcrest.Matchers.equalTo;

public class UsageOfSteps {
    private static final String FIELD = "usageOf";

    @Then("^the (?:word|phrase) is an example usage of the following$")
    public void verifyUsagesAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), equalTo(dataTable.asList()));
    }

    @Then("the word is not an example usage of anything")
    public void verifyUsageOfArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }
}
