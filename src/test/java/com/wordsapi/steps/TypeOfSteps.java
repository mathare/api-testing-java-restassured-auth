package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.empty;
import static org.hamcrest.Matchers.equalTo;

public class TypeOfSteps {

    @Then("the word is an example of the following types")
    public void verifyAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get("typeOf"), equalTo(dataTable.asList()));
    }

    @Then("the word is not a \"type of\" anything")
    public void verifyTypeOfArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get("typeOf"), empty());
    }
}
