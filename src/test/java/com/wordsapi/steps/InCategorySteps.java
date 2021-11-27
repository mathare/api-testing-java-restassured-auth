package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class InCategorySteps {
    private static final String FIELD = "inCategory";

    @Then("^the (?:word|phrase) is in the following categories$")
    public void verifyCategoriesAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), equalTo(dataTable.asList()));
    }

    @Then("the word is in no categories")
    public void verifyCategoriesArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }

    @Then("the word is in {int} categories")
    public void verifyNumCategories(int numCategories) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), hasSize(numCategories));
    }
}
