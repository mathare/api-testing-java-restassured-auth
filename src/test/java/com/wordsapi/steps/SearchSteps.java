package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import java.io.File;
import java.util.List;

import static com.wordsapi.steps.CommonSteps.*;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class SearchSteps {

    @Then("there are a total of {int} results")
    public void verifyNumResults(int numResults) {
        assertThat(JsonPath.from(response.asString()).get("results.total"), equalTo(numResults));
    }

    @Then("the following words are returned")
    public void verifyWordsAgainstDataTable(DataTable dataTable) {
        assertThat(JsonPath.from(response.asString()).get("results.data"), equalTo(dataTable.asList()));
    }

    @Then("^the (limit|page) value in the response body is (\\d+)")
    public void verifyQueryValue(String param, int value) {
        assertThat(JsonPath.from(response.asString()).get("query." + param), equalTo(value));
    }

    @Then("^the (limit|page) value in the response body is \"(\\w+|-?[0-9]*\\.?[0-9]+)\"")
    public void verifyQueryValue(String param, String value) {
        assertThat(JsonPath.from(response.asString()).get("query." + param), equalTo(value));
    }

    @Then("{int} words are returned")
    public void verifyNumWords(int numWords) {
        assertThat(JsonPath.from(response.asString()).get("results.data"), hasSize(numWords));
    }

    @Then("the words returned in both response bodies are identical")
    public void verifyAllResponsesIdentical() {
        for (int i = 1; i < responses.size(); i++) {
            assertThat(JsonPath.from(responses.get(i).asString()).get("results.data"),
                    equalTo(JsonPath.from(responses.get(0).asString()).get("results.data")));
        }
    }

    @Then("^the words in the response body are the (\\d+).{2} to the (\\d+).{2} in the full results set")
    public void verifyWordsReturnedAgainstFullResultsSet(int fromIndex, int toIndex) {
        List<String> actual = JsonPath.from(response.asString()).get("results.data");
        String filename = BASE_RESOURCES_DIR + "AllWords.json";
        List<String> allWords = JsonPath.from(new File(filename)).get("results.data");
        List<String> expected = allWords.subList(fromIndex - 1, toIndex);
        assertThat(actual, equalTo(expected));
    }

    @Then("the \"word\" value in the response bodies differs")
    public void verifyWordDiffersBetweenRandomResponses() {
        assertThat(JsonPath.from(responses.get(1).asString()).get("word"),
                not(equalTo(JsonPath.from(responses.get(0).asString()).get("word"))));
    }

    @Then("the returned word has {int} letters")
    public void verifyWordLength(int numLetters) {
        //Returned word could be a multi-word phrase so remove spaces which don't count as letters
        String word = JsonPath.from(response.asString()).get("word").toString().replaceAll(" ", "");
        assertThat(word.length(), equalTo(numLetters));
    }
}
