package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.hasSize;

public class RhymesSteps {
    private static final String FIELD = "rhymes";
    private static final String ALL = FIELD + ".all";
    private static final String NOUN = FIELD + ".noun";
    private static final String VERB = FIELD + ".verb";

    @Then("the word has the following rhymes")
    public void verifyRhymesAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get(ALL), equalTo(dataTable.asList()));
    }

    @Then("the word has no rhymes")
    public void verifyRhymesArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD).toString(), equalTo("{}"));
    }

    @Then("^the (noun|verb) form of the word has (\\d+) rhymes?$")
    public void verifyNumRhymes(String wordForm, int numRhymes) {
        String field = wordForm.equals("noun") ? NOUN : VERB;
        assertThat(JsonPath.from(response.asString()).get(field), hasSize(numRhymes));
    }

    @Then("the word has {int} rhyme(s)")
    public void verifyNumRhymes(int numRhymes) {
        assertThat(JsonPath.from(response.asString()).get(ALL), hasSize(numRhymes));
    }
}