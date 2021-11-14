package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class HasPartsSteps {
    private static final String FIELD = "hasParts";

    @Then("the word has the following parts")
    public void verifyPartsAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), equalTo(dataTable.asList()));
    }

    @Then("the word has no parts")
    public void verifyHasPartsArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }

    @Then("the word has {int} parts")
    public void verifyNumParts(int numParts) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), hasSize(numParts));
    }
}
