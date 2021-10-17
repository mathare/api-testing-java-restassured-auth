package com.typicode.jsonplaceholder.helpers;

import io.restassured.RestAssured;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
public class RequestHelpers {

    private static final String BASE_URL = "https://wordsapiv1.p.rapidapi.com/words/";
    private static RequestSpecification request = RestAssured.given().header("x-rapidapi-key", System.getProperty("API_KEY"));

    public static Response sendGetRequest(String endpoint, String word) {
        return request.get(BASE_URL + word + "/" + endpoint);
    }
}
