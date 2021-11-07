package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static com.wordsapi.steps.CommonSteps.response;
import static com.wordsapi.steps.CommonSteps.responses;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class EverythingSteps {

    private final JsonPath json = JsonPath.from(response.asString());
    private final List<Map<String, String>> results = json.get("results");
    private final List<Integer> indices = new ArrayList<>();

    @Then("the response body contains {int} definition(s)")
    public void verifyNumDefinitions(int numDefinitions) {
        if (numDefinitions == 0) {
            assertThat(results, equalTo(null));
        } else {
            assertThat(results, hasSize(numDefinitions));
        }
    }

    @Then("the definition is")
    public void verifyDefinition(String definition) {
        assertThat(results.get(0).get("definition"), equalTo(definition));
    }

    @Then("the definitions are")
    public void verifyDefinition(DataTable dataTable) {
        List<String> definitions = dataTable.asList();
        assertThat(results.size(), equalTo(definitions.size()));
        for (int i = 0; i < definitions.size(); i++) {
            assertThat(results.get(i).get("definition"), equalTo(definitions.get(i)));
        }
    }

    @Then("^all the definitions are (\\w+)$")
    public void verifyAllPartsOfSpeech(String partOfSpeech) {
        CommonSteps.verifyPartsOfSpeech(results.size(), partOfSpeech);
    }

    @Then("^the \"(\\w+)\" field in the (\\d+).{2} result has the following values")
    public void verifyFieldInResult(String field, int index, DataTable dataTable) {
        indices.add(index - 1);
        assertThat(json.get(String.format("results[%d].%s", index - 1, field)).toString(), equalTo(dataTable.asList().toString()));
    }

    @Then("there is no {string} field in the other results")
    public void verifyFieldNotPresentInOtherResults(String field) {
        for (int i = 0; i < results.size(); i++) {
            if (!indices.contains(i)) {
                assertThat(json.get(String.format("results[%d].%s", i, field)), equalTo(null));
            }
        }
    }

    @Then("the word rhymes with {string}")
    public void verifyRhyme(String rhyme) {
        assertThat(json.get("rhymes.all"), equalTo(rhyme));
    }

    @Then("the word has {int} syllables")
    public void verifyNumSyllables(int numSyllables) {
        assertThat(json.get("syllables.count"), equalTo(numSyllables));
    }

    @Then("the word has the following syllables")
    public void verifySyllables(DataTable dataTable) {
        assertThat(json.get("syllables.list"), equalTo(dataTable.asList()));
    }

    @Then("the word is pronounced {string}")
    public void verifyPronunciation(String pronunciation) {
        assertThat(json.get("pronunciation.all"), equalTo(pronunciation));
    }

    @Then("the word has the following pronunciations")
    public void verifyPronunciations(DataTable dataTable) {
        Map<String, String> pronunciations = dataTable.asMap(String.class, String.class);
        for (String key : pronunciations.keySet()) {
            assertThat(json.get("pronunciation." + key), equalTo(pronunciations.get(key)));
        }
    }

    @Then("the word has a frequency of {float}")
    public void verifyFrequency(float frequency) {
        assertThat(json.get("frequency"), equalTo(frequency));
    }

    @Then("the response bodies differ")
    public void verifyResponseBodiesDiffer() {
        // As simple comparison of responses will differ on the "word" field since each request is for a different word
        // so set that field equal in both responses before comparing them
        String firstResponse = responses.get(0).asString();
        String secondResponse = responses.get(1).asString();
        String firstWord = JsonPath.from(firstResponse).get("word");
        String secondWord = JsonPath.from(secondResponse).get("word");
        secondResponse = secondResponse.replace(String.format("\"word\":\"%s\"", secondWord), String.format("\"word\":\"%s\"", firstWord));
        assertThat(firstResponse, not(secondResponse));
    }
}
