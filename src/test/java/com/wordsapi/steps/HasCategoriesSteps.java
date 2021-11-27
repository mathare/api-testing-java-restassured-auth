package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class HasCategoriesSteps {
    private static final String FIELD = "hasCategories";

    @Then("^the (?:word|phrase) has the following categories$")
    public void verifyCategoriesAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), equalTo(dataTable.asList()));
    }

    @Then("the word has no categories")
    public void verifyHasCategoriesArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }

    @Then("the word has {int} categories")
    public void verifyNumCategories(int numCategories) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), hasSize(numCategories));
    }
}
