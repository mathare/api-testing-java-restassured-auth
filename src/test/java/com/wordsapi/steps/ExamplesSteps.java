package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.empty;
import static org.hamcrest.Matchers.equalTo;

public class ExamplesSteps {
    private static final String FIELD = "examples";

    @Then("the word has the following examples")
    public void verifyExamplesAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), equalTo(dataTable.asList()));
    }

    @Then("the word has no examples")
    public void verifyExamplesArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }
}
