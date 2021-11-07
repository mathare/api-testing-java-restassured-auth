package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import java.util.List;
import java.util.Map;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class DefinitionsSteps {
    private static final String FIELD = "definitions";

    @Then("the word has the following definitions")
    public void verifyDefinitionsAgainstDataTable(DataTable dataTable) {
        //Strip header row off datatable
        dataTable = dataTable.rows(1);
        List<Map<String, String>> definitions = JsonPath.from(response.asString()).get(FIELD);
        for (int i = 0; i < definitions.size(); i++) {
            assertThat(definitions.get(i).get("definition"), equalTo(dataTable.cell(i, 0)));
            assertThat(definitions.get(i).get("partOfSpeech"), equalTo(dataTable.cell(i, 1)));
        }
    }

    @Then("the word has no definitions")
    public void verifyDefinitionsArrayEmpty() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), empty());
    }

    @Then("the word has {int} definition(s)")
    public void verifyNumDefinitions(int numDefinitions) {
        assertThat(JsonPath.from(response.asString()).get(FIELD), hasSize(numDefinitions));
    }

    @Then("^the definition is (?:a|an) (\\w+)$")
    public void verifyPartsOfSpeech(String partOfSpeech) {
        CommonSteps.verifyPartsOfSpeech(1, partOfSpeech);
    }
}
