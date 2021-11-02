package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;
import org.apache.commons.lang3.NotImplementedException;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.hasSize;

public class EverythingSteps {

    private static final List<String> PARTS_OF_SPEECH = Arrays.asList("adjective", "adverb", "noun", "preposition", "pronoun", "verb");
    private final JsonPath json = JsonPath.from(CommonSteps.response.asString());
    private final List<Map<String, String>> results = json.get("results");
    private final List<Integer> indices = new ArrayList<>();

    @Then("the word field in the response body is {string}")
    public void verifyWord(String word) {
        assertThat(json.get("word"), equalTo(word));
    }

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

    @Then("^(\\d+) of the definitions (?:are|is (?:a|an)) (\\w+)$")
    public void verifyPartsOfSpeech(int occurrences, String partOfSpeech) {
        if (partOfSpeech.endsWith("s")) partOfSpeech = partOfSpeech.substring(0, partOfSpeech.length() - 1);
        if (PARTS_OF_SPEECH.contains(partOfSpeech)) {
            int count = 0;
            for (Map<String, String> result : results) {
                if (result.get("partOfSpeech") != null && result.get("partOfSpeech").equals(partOfSpeech)) count++;
            }
            assertThat(count, equalTo(occurrences));
        } else {
            throw new NotImplementedException("Unknown part of speech: " + partOfSpeech);
        }
    }

    @Then("^all the definitions are (\\w+)$")
    public void verifyPartsOfSpeech(String partOfSpeech) {
        verifyPartsOfSpeech(results.size(), partOfSpeech);
    }

    @Then("^the \"(\\w+)\" field in the (\\d+).{2} result has the following values")
    public void verifyFieldInResult(String field, int index, DataTable dataTable) {
        indices.add(index - 1);
        assertThat(json.get(String.format("results[%d].%s", index-1, field)).toString(), equalTo(dataTable.asList().toString()));
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

}
