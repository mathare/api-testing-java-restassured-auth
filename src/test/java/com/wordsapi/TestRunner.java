package com.wordsapi;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
        features = "src/test/java/com/wordsapi/features",
        glue = "com.wordsapi.steps",
        tags = "not @skip",
        plugin = {"pretty", "html:target/cucumber-report.html"}
)

public class TestRunner {
}
