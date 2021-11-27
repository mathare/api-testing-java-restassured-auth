package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class AlsoSteps {
    private static final String FIELD = "also";

    @Then("^the (?:word|phrase) has the following \"also\" values$")
    public void verifyAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), equalTo(dataTable.asList()));
    }

    @Then("the word has no \"also\" values")
    public void verifyAlsoArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }

    @Then("the word has {int} \"also\" values")
    public void verifyNumAlsos(int numAlsos) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), hasSize(numAlsos));
    }
}
