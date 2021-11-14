package com.wordsapi.steps;

import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.Then;
import io.restassured.path.json.JsonPath;

import java.util.Map;

import static com.wordsapi.steps.CommonSteps.response;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.nullValue;

public class FrequencySteps {
    private static final String FIELD = "frequency";
    private static final String ZIPF = FIELD + ".zipf";
    private static final String PER_MILLION = FIELD + ".perMillion";
    private static final String DIVERSITY = FIELD + ".diversity";

    @Then("the word has the following frequency values")
    public void verifyFrequencyValuesAgainstDataTable(DataTable dataTable) {
        Map<String, Float> frequencies = dataTable.asMap(String.class, Float.class);
        for (String key : frequencies.keySet()) {
            assertThat(JsonPath.from(response.asString()).get(FIELD + "." + key), equalTo(frequencies.get(key)));
        }
    }

    @Then("^the word has a \"(zipf|perMillion|diversity)\" frequency value of ([0-9]+[.][0-9]+)$")
    public void verifyFrequencyValue(String frequencyType, float frequencyValue) {
        assertThat(JsonPath.from(response.asString()).get(FIELD + "." + frequencyType), equalTo(frequencyValue));
    }

    @Then("^the word has a \"(zipf|perMillion|diversity)\" frequency value of (0|1)$")
    public void verifyFrequencyValueIsZero(String frequencyType, int frequencyValue) {
        assertThat(JsonPath.from(response.asString()).get(FIELD + "." + frequencyType), equalTo(frequencyValue));
    }

    @Then("the word has no frequency values")
    public void verifyNoFrequencyValues() {
        assertThat(JsonPath.from(response.asString()).get(FIELD), nullValue());
    }
}