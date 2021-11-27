package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class HasUsagesSteps {
    private static final String FIELD = "hasUsages";

    @Then("the word has the following usages")
    public void verifyUsagesAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), equalTo(dataTable.asList()));
    }

    @Then("the word has no usages")
    public void verifyHasUsagesArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }

    @Then("^the (?:word|phrase) has (\\d+) usages$")
    public void verifyNumUsages(int numUsages) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), hasSize(numUsages));
    }
}
