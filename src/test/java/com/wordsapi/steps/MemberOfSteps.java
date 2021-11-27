package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class MemberOfSteps {
    private static final String FIELD = "memberOf";

    @Then("^the (?:word|phrase) is a member of the following$")
    public void verifyMembersAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), equalTo(dataTable.asList()));
    }

    @Then("the word is not a member of anything")
    public void verifyMemberOfArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }

    @Then("the word is a member of {int} things")
    public void verifyNumThingsMemberOf(int numThings) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), hasSize(numThings));
    }
}
