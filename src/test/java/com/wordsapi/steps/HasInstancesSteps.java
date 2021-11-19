package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class HasInstancesSteps {
    private static final String FIELD = "hasInstances";

    @Then("the word has the following instances")
    public void verifyInstancesAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), equalTo(dataTable.asList()));
    }

    @Then("the word has no instances")
    public void verifyHasInstancesArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }

    @Then("the word has {int} instances")
    public void verifyNumInstances(int numInstances) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), hasSize(numInstances));
    }
}
