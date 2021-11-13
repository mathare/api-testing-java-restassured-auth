package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.empty;
import static org.hamcrest.Matchers.equalTo;

public class AntonymsSteps {
    private static final String FIELD = "antonyms";

    @Then("the word has the following antonyms")
    public void verifyAntonymsAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), equalTo(dataTable.asList()));
    }

    @Then("the word has no antonyms")
    public void verifyAntonymsArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }
}
