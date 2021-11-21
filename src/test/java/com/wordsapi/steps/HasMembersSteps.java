package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class HasMembersSteps {
    private static final String FIELD = "hasMembers";

    @Then("the word has the following members")
    public void verifyMembersAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), equalTo(dataTable.asList()));
    }

    @Then("the word has no members")
    public void verifyHasMembersArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }

    @Then("the word has {int} members")
    public void verifyNumMembes(int numMembers) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), hasSize(numMembers));
    }
}
