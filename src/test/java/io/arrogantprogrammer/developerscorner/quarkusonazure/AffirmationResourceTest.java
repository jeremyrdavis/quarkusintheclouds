package io.arrogantprogrammer.developerscorner.quarkusonazure;

import io.quarkus.test.junit.QuarkusTest;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.is;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

@QuarkusTest
public class AffirmationResourceTest {

    @Test
    void testHelloEndpoint() {
        Response response = given()
                .when().get("/affirmation");
        assertEquals(200, response.statusCode());
        JsonPath jsonPath = response.jsonPath();
        String affirmation = jsonPath.getString("affirmation");
        assertTrue(Affirmation.getAffirmations().contains(affirmation));
        String author = jsonPath.getString("author");
        assertTrue(Affirmation.getAuthors().contains(author));
    }

    String expectedResponse = "{\"affirmation\":\"You are awesome!\",\"author\":\"Motivation Jane\"}";

}
