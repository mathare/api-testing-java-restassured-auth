package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class RegionOfSteps {
    private static final String FIELD = "regionOf";

    @Then("the following words are used in this region")
    public void verifyRegionalWordsAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), equalTo(dataTable.asList()));
    }

    @Then("no words are specific to this region")
    public void verifyRegionalWordsArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }

    @Then("{int} words are specific to this region")
    public void verifyNumRegionalWord(int numWords) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), hasSize(numWords));
    }
}
