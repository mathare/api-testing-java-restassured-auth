package com.typicode.jsonplaceholder;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
        features = "src/test/java/com/typicode/jsonplaceholder/features/TypeOf.feature",
        glue = "com.typicode.jsonplaceholder.steps",
        tags = "not @skip",
        plugin = {"pretty", "html:target/cucumber-report.html"}
)

public class TestRunner {
}
