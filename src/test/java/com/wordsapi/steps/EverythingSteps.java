package com.wordsapi.steps;

import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;
import org.apache.commons.lang3.NotImplementedException;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.hasSize;

public class EverythingSteps {

    private static final List<String> PARTS_OF_SPEECH = Arrays.asList("adjective", "adverb", "noun", "preposition", "pronoun", "verb");
    private final JsonPath json = JsonPath.from(CommonSteps.response.asString());

    @Then("the word field in the response body is {string}")
    public void verifyWord(String word) {
        assertThat(json.get("word"), equalTo(word));
    }

    @Then("the response body contains {int} definition(s)")
    public void verifyNumDefinitions(int numDefinitions) {
        if (numDefinitions == 0) {
            assertThat(json.get("results"), equalTo(null));
        } else {
            assertThat(json.get("results"), hasSize(numDefinitions));
        }
    }

    @Then("^(\\d+) of the definitions (?:are|is (?:a|an)) (\\w+)$")
    public void verifyPartsOfSpeech(int occurrences, String partOfSpeech) {
        if (partOfSpeech.endsWith("s")) partOfSpeech = partOfSpeech.substring(0, partOfSpeech.length() - 1);
        if (PARTS_OF_SPEECH.contains(partOfSpeech)) {
            List<Map<String, String>> results = json.get("results");
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
        List<Map<String, String>> results = json.get("results");
        verifyPartsOfSpeech(results.size(), partOfSpeech);
    }
}
